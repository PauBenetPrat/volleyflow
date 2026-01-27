import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volleyball_coaching_app/features/match/data/match_preferences_service.dart';
import 'package:volleyball_coaching_app/features/match/domain/models/match_configuration.dart';
import 'package:volleyball_coaching_app/features/match/presentation/widgets/match_settings_dialog.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  int _teamAScore = 0;
  int _teamBScore = 0;
  int _setNumber = 1;
  int _teamASets = 0;
  int _teamBSets = 0;
  bool? _isTeamAServing; // null = unknown, true = Team A, false = Team B
  bool _areSidesSwitched = false;

  // Removed _isMatchActive as requested - match is always 'active' for interaction
  MatchConfiguration _matchConfig = MatchConfiguration.defaultConfig;
  final _prefsService = MatchPreferencesService();

  @override
  void initState() {
    super.initState();
    // Force landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _loadMatchConfiguration();
  }

  @override
  void dispose() {
    // Reset orientation preference when leaving screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  Future<void> _loadMatchConfiguration() async {
    final config = await _prefsService.loadMatchConfiguration();
    setState(() {
      _matchConfig = config;
    });
  }

  void _resetMatch() {
    setState(() {
      _teamAScore = 0;
      _teamBScore = 0;
      _setNumber = 1;
      _teamASets = 0;
      _teamBSets = 0;
      _isTeamAServing = null;
    });
  }

  void _toggleServe() {
    setState(() {
      if (_isTeamAServing == null) {
        _isTeamAServing = true;
      } else {
        _isTeamAServing = !_isTeamAServing!;
      }
    });
  }

  void _incrementScore(bool isTeamA) {
    setState(() {
      if (isTeamA) {
        _teamAScore++;
      } else {
        _teamBScore++;
      }
      
      // Update serving team - the team that scored gets the serve
      _isTeamAServing = isTeamA;

      // Get winning score from configuration
      final winningScore = _matchConfig.getMaxPointsForSet(_teamASets, _teamBSets);
      final scoreDiff = (isTeamA ? _teamAScore : _teamBScore) - 
                        (isTeamA ? _teamBScore : _teamAScore);

      // Check if set is won
      bool setWon = (isTeamA ? _teamAScore : _teamBScore) >= winningScore;
      if (_matchConfig.winByTwo) {
        setWon = setWon && scoreDiff >= 2;
      }

      if (setWon) {
        // Set won
        if (isTeamA) {
          _teamASets++;
        } else {
          _teamBSets++;
        }

        // Check if match is won
        if (_teamASets >= _matchConfig.setsToWin || _teamBSets >= _matchConfig.setsToWin) {
          final l10n = AppLocalizations.of(context)!;
          _showMatchWinnerDialog(isTeamA ? l10n.teamA : l10n.teamB);
        } else {
          // Start next set
          _setNumber++;
          _teamAScore = 0;
          _teamBScore = 0;
          _isTeamAServing = null; // New set, serve is reset (usually loser serves or coin toss, keep simpler for now)
          
          // Switch sides automatically after each set
          _areSidesSwitched = !_areSidesSwitched;
        }
      }
    });
  }

  void _decrementScore(bool isTeamA) {
    setState(() {
      if (isTeamA && _teamAScore > 0) {
        _teamAScore--;
      } else if (!isTeamA && _teamBScore > 0) {
        _teamBScore--;
      }
    });
  }

  void _switchSides() {
    setState(() {
      _areSidesSwitched = !_areSidesSwitched;
    });
  }

  void _showMatchWinnerDialog(String winner) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.matchWon),
        content: Text(l10n.matchWonMessage(winner)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetMatch();
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  Future<void> _showMatchSettings() async {
    // Settings can be changed anytime now since we handle match state differently
    // However, if we want to prevent mid-game changes we could check score
    final scoreInProgress = _teamAScore > 0 || _teamBScore > 0 || _teamASets > 0 || _teamBSets > 0;
    
    // We can allow changing display storage (high contrast) anytime
    // But changing rules might be tricky. Let's allow it but warn if needed, 
    // or simplicity: just open dialog. The user requested specifically 'high contrast' setting.

    final newConfig = await showDialog<MatchConfiguration>(
      context: context,
      builder: (context) => MatchSettingsDialog(
        currentConfig: _matchConfig,
      ),
    );

    if (newConfig != null) {
      setState(() {
        _matchConfig = newConfig;
      });
      // Save configuration to preferences
      await _prefsService.saveMatchConfiguration(newConfig);
    }
  }

  Future<bool> _onWillPop() async {
    final l10n = AppLocalizations.of(context)!;
    
    // If no match in progress (no scores), just leave
    if (_teamAScore == 0 && _teamBScore == 0 && _teamASets == 0 && _teamBSets == 0) {
      return true;
    }

    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.leaveMatchTitle),
        content: Text(l10n.leaveMatchMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.stay),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.leave),
          ),
        ],
      ),
    );

    return shouldLeave ?? false;
  }

  Color get _teamAColor {
    if (_matchConfig.highContrastColors) {
      return Colors.red;
    }
    return Theme.of(context).colorScheme.primaryContainer;
  }

  Color get _teamBColor {
    if (_matchConfig.highContrastColors) {
      return Colors.green;
    }
    return Theme.of(context).colorScheme.secondaryContainer; 
  }

  Color _getTextColor(Color backgroundColor) {
    if (_matchConfig.highContrastColors) {
      return Colors.white;
    }
    return Theme.of(context).colorScheme.onPrimaryContainer;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.set(_setNumber)), // Header shows current set
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.swap_horiz),
              onPressed: _switchSides,
              tooltip: l10n.switchSides,
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showMatchSettings,
              tooltip: l10n.matchSettings,
            ),
          ],
        ),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Side
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0, right: 8.0),
                  child: _areSidesSwitched 
                    ? _buildTeamCard(
                        isTeamA: false,
                        name: l10n.teamB,
                        score: _teamBScore,
                        sets: _teamBSets,
                        color: _teamBColor,
                        isServing: _isTeamAServing == false,
                        canSetServe: _isTeamAServing == null,
                      )
                    : _buildTeamCard(
                        isTeamA: true,
                        name: l10n.teamA,
                        score: _teamAScore,
                        sets: _teamASets,
                        color: _teamAColor,
                        isServing: _isTeamAServing == true,
                        canSetServe: _isTeamAServing == null,
                      ),
                ),
              ),
              
              // Right Side
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 16.0, bottom: 16.0, right: 16.0),
                  child: _areSidesSwitched 
                    ? _buildTeamCard(
                        isTeamA: true,
                        name: l10n.teamA,
                        score: _teamAScore,
                        sets: _teamASets,
                        color: _teamAColor,
                        isServing: _isTeamAServing == true,
                        canSetServe: _isTeamAServing == null,
                      )
                    : _buildTeamCard(
                        isTeamA: false,
                        name: l10n.teamB,
                        score: _teamBScore,
                        sets: _teamBSets,
                        color: _teamBColor,
                        isServing: _isTeamAServing == false,
                        canSetServe: _isTeamAServing == null,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCard({
    required bool isTeamA,
    required String name,
    required int score,
    required int sets,
    required Color color,
    required bool isServing,
    required bool canSetServe,
  }) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final textColor = _getTextColor(color);

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: () => _incrementScore(isTeamA),
        borderRadius: BorderRadius.circular(24.0),
        child: Stack(
          children: [
            // Serve Indicator
            if (isServing)
              Positioned(
                top: 16,
                right: isTeamA && !_areSidesSwitched || !isTeamA && _areSidesSwitched ? 16 : null,
                left: !isTeamA && !_areSidesSwitched || isTeamA && _areSidesSwitched ? 16 : null,
                child: GestureDetector(
                  onTap: _toggleServe,
                  child: const Icon(
                    Icons.sports_volleyball,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              )
            else if (canSetServe)
              Positioned(
                top: 16,
                right: isTeamA && !_areSidesSwitched || !isTeamA && _areSidesSwitched ? 16 : null,
                left: !isTeamA && !_areSidesSwitched || isTeamA && _areSidesSwitched ? 16 : null,
                child: GestureDetector(
                  onTap: () => setState(() => _isTeamAServing = isTeamA),
                  child: Icon(
                    Icons.sports_volleyball,
                    color: Colors.white.withValues(alpha: 0.3),
                    size: 40,
                  ),
                ),
              ),
            
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   // Team Name and Sets display
                  Text(
                    '$name (${l10n.sets(sets)})',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$score',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 120, // Very large score
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 48), // Add spacing between score and decrement button
                ],
              ),
            ),
            // Decrement button at bottom center
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: IconButton.filled(
                  onPressed: () => _decrementScore(isTeamA),
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
