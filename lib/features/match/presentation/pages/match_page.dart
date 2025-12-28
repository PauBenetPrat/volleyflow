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
    });
  }

  void _incrementScore(bool isTeamA) {
    setState(() {
      if (isTeamA) {
        _teamAScore++;
      } else {
        _teamBScore++;
      }

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
              // Team A (Left Half)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0, right: 8.0),
                  child: Material(
                    color: _teamAColor,
                    borderRadius: BorderRadius.circular(24.0),
                    child: InkWell(
                      onTap: () => _incrementScore(true),
                      borderRadius: BorderRadius.circular(24.0),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.teamA,
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _getTextColor(_teamAColor),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '$_teamAScore',
                                  style: theme.textTheme.displayLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 120, // Very large score
                                    color: _getTextColor(_teamAColor),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    l10n.sets(_teamASets),
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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
                                onPressed: () => _decrementScore(true),
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
                  ),
                ),
              ),
              
              // Team B (Right Half)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 16.0, bottom: 16.0, right: 16.0),
                  child: Material(
                    color: _teamBColor,
                    borderRadius: BorderRadius.circular(24.0),
                    child: InkWell(
                      onTap: () => _incrementScore(false),
                      borderRadius: BorderRadius.circular(24.0),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.teamB,
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _getTextColor(_teamBColor),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '$_teamBScore',
                                  style: theme.textTheme.displayLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 120, // Very large score
                                    color: _getTextColor(_teamBColor),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    l10n.sets(_teamBSets),
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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
                                onPressed: () => _decrementScore(false),
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
