import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui' as ui;
import '../../../teams/domain/models/team.dart';
import '../../../teams/domain/models/player.dart';
import '../../../teams/domain/models/match_roster.dart';
import '../widgets/full_court_widget.dart';
import '../widgets/player_swap_dialog.dart';
import '../../domain/providers/match_state_provider.dart';
import '../../../teams/domain/providers/match_rosters_provider.dart';

import '../widgets/full_court_controller.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';

class FullCourtRotationsPage extends ConsumerStatefulWidget {
  final Team team;
  final MatchRoster? matchRoster;

  const FullCourtRotationsPage({
    super.key,
    required this.team,
    this.matchRoster,
  });

  @override
  ConsumerState<FullCourtRotationsPage> createState() => _FullCourtRotationsPageState();
}

class _FullCourtRotationsPageState extends ConsumerState<FullCourtRotationsPage> with WidgetsBindingObserver, TickerProviderStateMixin {
  // State
  final Map<String, Offset> _playerPositions = {}; // ID -> Position
  final Map<String, Player> _players = {}; // ID -> Player
  final Map<String, int> _playerLogicalPositions = {}; // ID -> Logical Position (1-6)
  final List<Player> _homeBench = [];
  final List<Player> _opponentBench = [];
  bool _isZoomed = false;
  bool _isHomeOnLeft = true;
  int _homeRotation = 1;
  int _opponentRotation = 1;
  bool _isDrawingMode = false;
  bool _showPlayerNumbers = true; // Default to showing numbers
  final FullCourtController _controller = FullCourtController();
  




  void _showStartingLineupDialog() async {
    final allPlayers = widget.team.players;
    if (allPlayers.length < 6) return; // Not enough players

    final selected = Set<String>.from(allPlayers.take(6).map((p) => p.id));
    
    final result = await showDialog<List<Player>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.selectStarting6),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: allPlayers.length,
                  itemBuilder: (context, index) {
                    final player = allPlayers[index];
                    final isSelected = selected.contains(player.id);
                    return CheckboxListTile(
                      title: Text('${player.number}. ${player.name}'),
                      value: isSelected,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            if (selected.length < 6) {
                              selected.add(player.id);
                            }
                          } else {
                            selected.remove(player.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: selected.length == 6 
                    ? () => Navigator.pop(context, allPlayers.where((p) => selected.contains(p.id)).toList()) 
                    : null,
                  child: Text(l10n.start),
                ),
              ],
            );
          },
        );
      },
    );
    
    if (result != null) {
      _initializePlayers(starters: result);
    }
  }

  @override
  void dispose() {
    // Dispose animation controllers
    _homeScoreAnimationController.dispose();
    _opponentScoreAnimationController.dispose();

    // Restore all orientations when leaving the page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Enforce landscape again to be sure
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _checkOrientation();
  }

  @override
  void didChangeMetrics() {
    // _checkOrientation(); // handled by didChangeDependencies usually, but keeping for safety if needed
    // Actually didChangeMetrics fires for keyboard etc, didChangeDependencies fires for MediaQuery
  }

  void _checkOrientation() {
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;
    
    // User reported "zooming out when going portrait" with previous logic.
    // Previous logic: isPortrait -> Zoom In.
    // If user saw Zoom Out, then isPortrait was false?
    // Let's enforce: Portrait -> Zoom In (isZoomed = true), Landscape -> Zoom Out (isZoomed = false)
    
    if (isPortrait && !_isZoomed) {
      setState(() {
        _isZoomed = true;
      });
    } else if (!isPortrait && _isZoomed) {
      setState(() {
        _isZoomed = false;
      });
    }
  }

  void _initializePlayers({List<Player>? starters}) {
    _playerPositions.clear();
    _players.clear();
    _playerLogicalPositions.clear();
    _homeBench.clear();
    _opponentBench.clear();

    // 1. Get roster - use match roster players if provided
    List<Player> roster;
    if (widget.matchRoster != null && widget.matchRoster!.playerIds != null && widget.matchRoster!.playerIds!.isNotEmpty) {
      // Filter team players to only include those in the match roster
      roster = widget.team.players
          .where((p) => widget.matchRoster!.playerIds!.contains(p.id))
          .toList();
    } else {
      roster = widget.team.players.toList();
    }
    
    final startingLineup = starters ?? roster.take(6).toList();
    
    // Add ALL roster players to the map to ensure they can be rendered
    for (final player in roster) {
      _players[player.id] = player;
    }
    
    // 2. Place placeholders on Left Side (Home)
    final startingPositions = _getStandardPositions(true);

    for (int i = 0; i < 6; i++) {
      final placeholderId = 'placeholder_$i';
      final placeholder = Player(
        id: placeholderId,
        name: '?',
        number: null,
      );
      _players[placeholderId] = placeholder;
      _playerPositions[placeholderId] = startingPositions[i];
      _playerLogicalPositions[placeholderId] = i + 1;
    }

    // Add ALL roster players to bench
    _homeBench.addAll(roster);

    // 3. Create 6 Ghost Players for Right Side (Opponent)
    final opponentPositions = _getStandardPositions(false);
    
    // Get saved opponent player numbers from state
    final savedState = ref.read(matchStateProvider);
    final savedOpponentNumbers = savedState?.opponentPlayerNumbers ?? {};

    for (int i = 0; i < 6; i++) {
      final ghostId = 'ghost_$i';
      // Use saved number if available, otherwise default to i+1
      final savedNumber = savedOpponentNumbers[ghostId];
      final ghostPlayer = Player(
        id: ghostId,
        name: 'Opponent',
        number: savedNumber ?? (i + 1),
      );
      _players[ghostId] = ghostPlayer;
      _playerPositions[ghostId] = opponentPositions[i];
      _playerLogicalPositions[ghostId] = i + 1;
    }
    
    setState(() {});
    _saveMatchState();
  }

  List<Offset> _getStandardPositions(bool isLeft) {
    if (isLeft) {
      return [
        const Offset(0.3, 0.8), // 1 (Back Right)
        const Offset(0.8, 0.8), // 2 (Front Right)
        const Offset(0.8, 0.5), // 3 (Front Center)
        const Offset(0.8, 0.2), // 4 (Front Left)
        const Offset(0.3, 0.2), // 5 (Back Left)
        const Offset(0.3, 0.5), // 6 (Back Center)
      ];
    } else {
      return [
        const Offset(1.7, 0.2), // 1 (Back Right - Top Right on screen)
        const Offset(1.2, 0.2), // 2 (Front Right - Top Left on screen)
        const Offset(1.2, 0.5), // 3 (Front Center)
        const Offset(1.2, 0.8), // 4 (Front Left - Bottom Left on screen)
        const Offset(1.7, 0.8), // 5 (Back Left - Bottom Right on screen)
        const Offset(1.7, 0.5), // 6 (Back Center)
      ];
    }
  }

  void _updateBallPositionForServe() {
    setState(() {
      // Determine which side is serving
      final bool servingSideIsLeft = _isHomeServing ? _isHomeOnLeft : !_isHomeOnLeft;
      
      if (servingSideIsLeft) {
        // Serving from left side (X < 1.0)
        _ballPosition = const Offset(0.05, 0.9);
      } else {
        // Serving from right side (X > 1.0)
        _ballPosition = const Offset(1.95, 0.1);
      }
    });
  }



  void _handlePlayerMoved(String playerId, Offset newPosition) {
    if (!_isDrawingMode) {
      setState(() {
        _playerPositions[playerId] = newPosition;
      });
      _saveMatchState();
    }
  }

  void _handlePlayerTap(String playerId) async {
    final player = _players[playerId];
    if (player == null) return;

    // If it's a ghost player, allow editing the number
    if (playerId.startsWith('ghost_')) {
      _editOpponentPlayerNumber(playerId, player);
      return;
    }

    // For real players, allow swapping with bench players
    // Determine which bench to use (Home bench)
    final bench = _homeBench;

    final selectedBenchPlayer = await showDialog<Player>(
      context: context,
      builder: (context) => PlayerSwapDialog(
        currentPlayer: player,
        benchPlayers: bench,
      ),
    );

    if (selectedBenchPlayer != null) {
      setState(() {
        // Swap positions
        final pos = _playerPositions[playerId];
        if (pos != null) {
          _playerPositions.remove(playerId);
          _playerPositions[selectedBenchPlayer.id] = pos;
          
          // Transfer logical position
          final logicalPos = _playerLogicalPositions[playerId];
          if (logicalPos != null) {
            _playerLogicalPositions.remove(playerId);
            _playerLogicalPositions[selectedBenchPlayer.id] = logicalPos;
          }
          
          // Update bench
          _homeBench.remove(selectedBenchPlayer);
          if (!player.id.startsWith('placeholder_')) {
            _homeBench.add(player);
          } else {
            _players.remove(player.id);
          }
        }
      });
      _saveMatchState();
    }
  }

  void _editOpponentPlayerNumber(String ghostId, Player player) async {
    final l10n = AppLocalizations.of(context)!;
    final numberController = TextEditingController(
      text: player.number?.toString() ?? '',
    );

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editOpponentPlayerNumber),
        content: TextField(
          controller: numberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.playerNumber,
            hintText: l10n.enterNumber,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              final number = int.tryParse(numberController.text);
              if (number != null && number >= 1 && number <= 99) {
                Navigator.pop(context, number);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _players[ghostId] = player.copyWith(number: result);
      });
      ref.read(matchStateProvider.notifier).updateOpponentPlayerNumber(ghostId, result);
      _saveMatchState();
    }
  }

  void _handleBenchPlayerTap(Player player, bool isLeftBench) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Player: ${player.name}')),
    );
  }

  void _resetPositions(bool isHome) {
    final isLeft = (_isHomeOnLeft && isHome) || (!_isHomeOnLeft && !isHome);
    final standardPositions = _getStandardPositions(isLeft);
    
    // Find players on this side
    final sidePlayers = _playerPositions.entries
        .where((entry) {
          final x = entry.value.dx;
          return isLeft ? x <= 1.0 : x > 1.0;
        })
        .toList();

    for (final entry in sidePlayers) {
      final logicalPos = _playerLogicalPositions[entry.key];
      if (logicalPos != null) {
        _playerPositions[entry.key] = standardPositions[logicalPos - 1];
      }
    }
  }

  void _rotateSide(bool isLeft, {bool clockwise = true}) async {
    // Determine if we are rotating Home or Opponent
    final isRotatingHome = (_isHomeOnLeft && isLeft) || (!_isHomeOnLeft && !isLeft);
    
    // Update rotation number
    setState(() {
      if (isRotatingHome) {
        if (clockwise) {
          _homeRotation = (_homeRotation % 6) + 1;
        } else {
          _homeRotation = (_homeRotation - 2 + 6) % 6 + 1;
        }
      } else {
        if (clockwise) {
          _opponentRotation = (_opponentRotation % 6) + 1;
        } else {
          _opponentRotation = (_opponentRotation - 2 + 6) % 6 + 1;
        }
      }
    });

    // Find players on this side
    final sidePlayers = _playerPositions.entries
        .where((entry) {
          final x = entry.value.dx;
          return isLeft ? x <= 1.0 : x > 1.0;
        })
        .toList();

    if (sidePlayers.isEmpty) return;

    // Update logical positions
    setState(() {
      if (clockwise) {
        for (final entry in sidePlayers) {
          final currentLogical = _playerLogicalPositions[entry.key];
      if (currentLogical != null) {
            _playerLogicalPositions[entry.key] = currentLogical == 1 ? 6 : currentLogical - 1;
          }
        }
      } else {
        for (final entry in sidePlayers) {
          final currentLogical = _playerLogicalPositions[entry.key];
          if (currentLogical != null) {
             _playerLogicalPositions[entry.key] = currentLogical == 6 ? 1 : currentLogical + 1;
          }
        }
      }
      
      // Reset physical positions to standard
      _resetPositions(isRotatingHome);
    });
    _saveMatchState();
  }

  void _rotateField() {
    setState(() {
      _isHomeOnLeft = !_isHomeOnLeft;
      
      final newPositions = <String, Offset>{};
      _playerPositions.forEach((id, pos) {
        // Rotate 180 degrees around center (1.0, 0.5)
        // New X = 2.0 - Old X
        // New Y = 1.0 - Old Y
        newPositions[id] = Offset(2.0 - pos.dx, 1.0 - pos.dy);
      });
      _playerPositions.clear();
      _playerPositions.addAll(newPositions);
    });
    // Update ball position after side change to reflect current server side
    _updateBallPositionForServe();
    _saveMatchState();
  }

  void _rotateFieldAndReset() {
    setState(() {
      _isHomeOnLeft = !_isHomeOnLeft;
      
      // Reset both teams to standard positions on their new sides
      _resetPositions(true);  // Reset Home
      _resetPositions(false); // Reset Opponent
    });
    // Ensure ball position reflects current server side after field rotation
    _updateBallPositionForServe();
    _saveMatchState();
  }

  // Match State
  int _homeScore = 0;
  int _opponentScore = 0;
  int _homeSets = 0;
  int _opponentSets = 0;
  int _currentSet = 1;
  bool _isHomeServing = true;
  Offset _ballPosition = const Offset(0.05, 0.9); // Default serve pos (Home)
  bool _matchStarted = false;
  bool _isMatchSetupMode = true;
  bool? _firstServerOfSet; // true = Home, false = Opponent
  bool _set5SwitchDone = false; // Track if court switch at 8 points in set 5 has been done

  // Animation controllers for score changes
  late AnimationController _homeScoreAnimationController;
  late AnimationController _opponentScoreAnimationController;
  late Animation<double> _homeScoreAnimation;
  late Animation<double> _opponentScoreAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize animation controllers
    _homeScoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200), // Fast expansion
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _homeScoreAnimationController.reverse();
      }
    });

    _opponentScoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200), // Fast expansion
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _opponentScoreAnimationController.reverse();
      }
    });
    
    // Create scale animations (1.0 -> 1.5 -> 1.0)
    _homeScoreAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _homeScoreAnimationController,
        curve: Curves.easeOut, // Fast out
        reverseCurve: Curves.easeIn, // Fast in
      ),
    );
    _opponentScoreAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _opponentScoreAnimationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
    
    // Force landscape orientation for better court visualization
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMatchState();
      _checkOrientation();
    });
  }

  Future<void> _loadMatchState() async {
    // Attempt to load from local database first
    await ref.read(matchStateProvider.notifier).loadFromDatabase();
    
    final savedState = ref.read(matchStateProvider);
    
    // Check if we have a saved state that matches the current roster (or if we are resuming the active match)
    // If widget.matchRoster is null, we might be resuming an ad-hoc match
    bool shouldRestore = false;
    
    if (savedState != null) {
      if (widget.matchRoster != null) {
        // If we opened a specific roster, only restore if it matches
        if (savedState.matchRoster?.id == widget.matchRoster?.id) {
          shouldRestore = true;
        }
      } else {
        // If we opened without a roster (e.g. direct navigation), restore whatever is there
        shouldRestore = true;
      }
    }
    
    if (shouldRestore && savedState != null) {
      final state = savedState;
      // Restore state from provider
      setState(() {
        // Clear and restore maps/lists
        _playerPositions.clear();
        _playerPositions.addAll(
          state.playerPositions.map((k, v) => MapEntry(k, Offset(v.dx, v.dy)))
        );
        _players.clear();
        _players.addAll(state.players);
        _playerLogicalPositions.clear();
        _playerLogicalPositions.addAll(state.playerLogicalPositions);
        _homeBench.clear();
        _homeBench.addAll(state.homeBench);
        _opponentBench.clear();
        _opponentBench.addAll(state.opponentBench);
        
        _homeScore = state.homeScore;
        _opponentScore = state.opponentScore;
        _homeSets = state.homeSets;
        _opponentSets = state.opponentSets;
        _currentSet = state.currentSet;
        _isHomeServing = state.isHomeServing;
        _ballPosition = state.ballPosition != null 
            ? Offset(state.ballPosition!.dx, state.ballPosition!.dy)
            : const Offset(0.5, 0.5); // Default fallback
            
        _matchStarted = state.matchStarted;
        _isMatchSetupMode = state.isMatchSetupMode;
        _firstServerOfSet = state.firstServerOfSet;
        _homeRotation = state.homeRotation;
        _opponentRotation = state.opponentRotation;
        
        // Restore opponent player numbers
        for (final entry in state.opponentPlayerNumbers.entries) {
          ref.read(matchStateProvider.notifier).updateOpponentPlayerNumber(entry.key, entry.value);
        }
      });
    } else {
      // Initialize new match - clear old state if different roster
      if (savedState != null && savedState.matchRoster?.id != widget.matchRoster?.id) {
        ref.read(matchStateProvider.notifier).resetMatch();
      }
      ref.read(matchStateProvider.notifier).initializeMatch(widget.matchRoster);
      _initializePlayers();
      _updateBallPositionForServe();
    }
  }

  void _saveMatchState() {
    final currentLogs = ref.read(matchStateProvider)?.logs ?? [];
    final currentState = MatchState(
      logs: currentLogs,
      matchRoster: widget.matchRoster,
      playerPositions: _playerPositions.map((k, v) => MapEntry(k, ui.Offset(v.dx, v.dy))),
      players: _players,
      playerLogicalPositions: _playerLogicalPositions,
      homeBench: _homeBench,
      opponentBench: _opponentBench,
      opponentPlayerNumbers: _getOpponentPlayerNumbers(),
      homeScore: _homeScore,
      opponentScore: _opponentScore,
      homeSets: _homeSets,
      opponentSets: _opponentSets,
      currentSet: _currentSet,
      isHomeServing: _isHomeServing,
      ballPosition: _ballPosition != null ? ui.Offset(_ballPosition!.dx, _ballPosition!.dy) : null,
      matchStarted: _matchStarted,
      isMatchSetupMode: _isMatchSetupMode,
      firstServerOfSet: _firstServerOfSet,
      homeRotation: _homeRotation,
      opponentRotation: _opponentRotation,
    );
    ref.read(matchStateProvider.notifier).updateState(currentState);
  }

  Map<String, int> _getOpponentPlayerNumbers() {
    final numbers = <String, int>{};
    for (final entry in _players.entries) {
      if (entry.key.startsWith('ghost_') && entry.value.number != null) {
        numbers[entry.key] = entry.value.number!;
      }
    }
    return numbers;
  }

  void _decrementScore(bool isHome) {
    setState(() {
      if (isHome) {
        if (_homeScore > 0) _homeScore--;
      } else {
        if (_opponentScore > 0) _opponentScore--;
      }
    });
  }

  void _incrementScore(bool isHome, {bool isAce = false}) {
    // Trigger animation for the scoring team
    if (isHome) {
      _homeScoreAnimationController.forward(from: 0.0);
    } else {
      _opponentScoreAnimationController.forward(from: 0.0);
    }

    // 1. Record the point log BEFORE updating the score (or after, depending on preference - usually we log the RESULTING score)
    // Let's calculate the resulting score first
    final newHomeScore = isHome ? _homeScore + 1 : _homeScore;
    final newOpponentScore = !isHome ? _opponentScore + 1 : _opponentScore;

    // Get current players on court (Home team)
    final homePlayerIds = _playerLogicalPositions.entries
        .where((e) => !e.key.startsWith('ghost_')) // Only real players
        .map((e) => e.key)
        .toList();

    final log = PointLog(
      homeScore: newHomeScore,
      opponentScore: newOpponentScore,
      setNumber: _currentSet,
      type: isAce 
          ? (isHome ? PointType.aceHome : PointType.aceOpponent) 
          : PointType.normal,
      homePlayerIds: homePlayerIds,
      timestamp: DateTime.now(),
      homeRotation: _homeRotation,
      opponentRotation: _opponentRotation,
    );

    // Add log to state
    ref.read(matchStateProvider.notifier).addLog(log);

    setState(() {
      if (isHome) {
        _homeScore++;
      } else {
        _opponentScore++;
      }
      
      // Update serve side based on who won the point
      // If serving team won point -> continue serving
      // If receiving team won point -> switch serve (and they will rotate)
      final bool wasHomeServing = _isHomeServing;
      _isHomeServing = isHome; // Winner serves
      
      // Check for rotation (Sideout)
      // Rotation happens when receiving team wins the point
      if (wasHomeServing != isHome) {
        if (isHome) {
          // Home team won point and wasn't serving -> Rotate Home
          _rotateSide(true);
        } else {
          // Opponent won point and wasn't serving -> Rotate Opponent
          _rotateSide(false);
        }
      }
      
      _updateBallPositionForServe();
      
      // Check for court switch in set 5 at 8 points
      if (_currentSet == 5 && !_set5SwitchDone && (_homeScore == 8 || _opponentScore == 8)) {
        _set5SwitchDone = true;
        _showCourtSwitchDialog();
      }
      
      _checkSetWin();
    });
    _saveMatchState();
  }

  void _undoLastPoint() {
    final state = ref.read(matchStateProvider);
    if (state == null) return;
    if (state.logs.isEmpty) return;

    // Remove last log from provider
    ref.read(matchStateProvider.notifier).removeLastLog();
    
    // Get parameters from the NEW last log (or initial state)
    final updatedLogs = ref.read(matchStateProvider)?.logs ?? [];
    
    int targetHomeScore = 0;
    int targetOpponentScore = 0;
    int targetHomeRotation = 1;
    int targetOpponentRotation = 1;
    int targetSet = 1;
    
    if (updatedLogs.isNotEmpty) {
      final lastLog = updatedLogs.last;
      targetHomeScore = lastLog.homeScore;
      targetOpponentScore = lastLog.opponentScore;
      targetHomeRotation = lastLog.homeRotation;
      targetOpponentRotation = lastLog.opponentRotation;
      targetSet = lastLog.setNumber;
    }
    
    // Determine Rotations to Undo
    // Since _rotateSide is async/setState based, we calculating trigger condition first
    bool undoHomeRotation = false;
    bool undoOpponentRotation = false;
    
    if (_homeRotation == (targetHomeRotation % 6) + 1) {
      undoHomeRotation = true;
    }
    if (_opponentRotation == (targetOpponentRotation % 6) + 1) {
      undoOpponentRotation = true;
    }
    
    setState(() {
      _homeScore = targetHomeScore;
      _opponentScore = targetOpponentScore;
      _currentSet = targetSet;
      
      // Determine Serve
      if (updatedLogs.isEmpty) {
         if (_firstServerOfSet != null) {
            _isHomeServing = _firstServerOfSet!;
         }
      } else {
         final lastLog = updatedLogs.last;
         int prevHomeScore = 0;
         if (updatedLogs.length > 1) {
             prevHomeScore = updatedLogs[updatedLogs.length - 2].homeScore;
         }
         
         if (lastLog.homeScore > prevHomeScore) {
             _isHomeServing = true;
         } else {
             _isHomeServing = false;
         }
      }
    });

    // Execute rotation undo if needed
    if (undoHomeRotation) {
      _rotateSide(true, clockwise: false);
    }
    if (undoOpponentRotation) {
      _rotateSide(false, clockwise: false);
    }
    
    _updateBallPositionForServe();
    _saveMatchState();
  }

  void _showCourtSwitchDialog() {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🔄 Court Switch - Set 5'),
        content: Text('Score: $_homeScore - $_opponentScore\n\nTeams switch sides at 8 points in the 5th set.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform the court switch
              _rotateFieldAndReset();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showFirstServeDialog() {
    final l10n = AppLocalizations.of(context)!;
    final homeName = widget.team.name;
    final oppName = widget.matchRoster?.rivalName ?? l10n.opponent;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.whoServesFirst),
        content: Text(l10n.selectTeamServesFirst),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startMatch(true);
            },
            child: Text(homeName),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startMatch(false);
            },
            child: Text(oppName),
          ),
        ],
      ),
    );
  }

  void _startMatch(bool isHomeServing) {
    setState(() {
      _matchStarted = true;
      _isMatchSetupMode = false;
      _firstServerOfSet = isHomeServing;
      _isHomeServing = isHomeServing;
      _updateBallPositionForServe();
    });
  }

  void _checkSetWin() {
    final winningScore = _currentSet == 5 ? 15 : 25;
    final home = _homeScore;
    final opp = _opponentScore;

    if ((home >= winningScore || opp >= winningScore) && (home - opp).abs() >= 2) {
      // Set Won
      setState(() {
        if (home > opp) {
          _homeSets++;
        } else {
          _opponentSets++;
        }
      });
      _saveMatchState();
      if (home > opp) {
        _showSetWinDialog(true);
      } else {
        _showSetWinDialog(false);
      }
    }
  }

  Future<void> _saveMatchResult() async {
    if (widget.matchRoster == null) return;
    
    try {
      final updatedRoster = widget.matchRoster!.copyWith(
        setsHome: _homeSets,
        setsOpponent: _opponentSets,
        matchCompleted: true,
        completedAt: DateTime.now(),
      );
      
      await ref.read(matchRostersProvider.notifier).updateRoster(updatedRoster);
    } catch (e) {
      print('Error saving match result: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save match result: $e')),
        );
      }
    }
  }

  void _showSetWinDialog(bool homeWon) {
    final l10n = AppLocalizations.of(context)!;
    final homeName = widget.team.name;
    final oppName = widget.matchRoster?.rivalName ?? l10n.opponent;
    final winner = homeWon ? homeName : oppName;
    
    // Check Match Win
    if (_homeSets == 3 || _opponentSets == 3) {
      // Save match result if we have a roster
      _saveMatchResult();
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('🏆 $winner Wins Match!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Final Score: $_homeSets - $_opponentSets'),
              const SizedBox(height: 16),
              const Text('Match result saved!', style: TextStyle(color: Colors.green)),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await _exportMatchLog();
              },
              icon: const Icon(Icons.share),
              label: const Text('Share Stats'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetMatch();
              },
              child: Text(l10n.newMatch),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('$winner Wins Set $_currentSet'),
          content: Text('Score: $_homeScore - $_opponentScore'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startNextSet();
              },
              child: Text(l10n.nextSet),
            ),
          ],
        ),
      );
    }
  }

  void _startNextSet() {
    setState(() {
      _currentSet++;
      _homeScore = 0;
      _opponentScore = 0;
      _set5SwitchDone = false; // Reset for next set (in case it's set 5)
      
      // Switch sides and reset positions (except before set 5)
      if (_currentSet != 5) {
         _rotateFieldAndReset();
      }
      
      // Alternate first server
      if (_firstServerOfSet != null) {
        _firstServerOfSet = !_firstServerOfSet!;
        _isHomeServing = _firstServerOfSet!;
      }
      
      _updateBallPositionForServe();
    });
    _saveMatchState();
  }

  Future<void> _exportMatchLog() async {
    final state = ref.read(matchStateProvider);
    if (state == null || state.logs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No match logs available')),
      );
      return;
    }

    final buffer = StringBuffer();
    // CSV Header
    buffer.writeln('Set,Home Score,Opponent Score,Type,Home Rotation,Opponent Rotation,Timestamp,Players on Court');

    for (final log in state.logs) {
      final playerNames = log.homePlayerIds
          .map((id) => _players[id]?.name ?? '?')
          .join(';');
      
      buffer.writeln(
        '${log.setNumber},'
        '${log.homeScore},'
        '${log.opponentScore},'
        '${log.type.name},'
        '${log.homeRotation},'
        '${log.opponentRotation},'
        '${log.timestamp.toIso8601String()},'
        '"$playerNames"'
      );
    }

    final csvData = buffer.toString();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    // Share as CSV file
    try {
      final box = context.findRenderObject() as RenderBox?;
      
      await Share.shareXFiles(
        [
          XFile.fromData(
            utf8.encode(csvData),
            mimeType: 'text/csv',
            name: 'match_log_$timestamp.csv',
          ),
        ],
        text: 'Volleyball Match Log',
        subject: 'Match Log - ${widget.team.name}',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    } catch (e) {
      // Fallback to clipboard if sharing fails
      Clipboard.setData(ClipboardData(text: csvData));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sharing failed. Copied to clipboard instead. Error: $e'),
          ),
        );
      }
    }
  }

  void _resetMatch() {
    setState(() {
      _homeScore = 0;
      _opponentScore = 0;
      _homeSets = 0;
      _opponentSets = 0;
      _currentSet = 1;
      _matchStarted = false;
      _isMatchSetupMode = true; // Reset to setup mode
      _firstServerOfSet = null;
      _set5SwitchDone = false; // Reset court switch flag
      _initializePlayers(); // Reset players to bench/placeholders
      _updateBallPositionForServe();
      // Note: matchRoster is kept in memory - it's part of widget state
      // Only cleared when navigating away or starting a new match
    });
    _saveMatchState();
  }

  void _startMatchSetup() {
    final l10n = AppLocalizations.of(context)!;
    // Validate 6 players
    final homePlayersOnCourt = _playerPositions.keys
        .where((id) => !id.startsWith('ghost_') && !id.startsWith('placeholder_'))
        .length;
        
    if (homePlayersOnCourt < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.placeSixPlayersToStart)),
      );
      return;
    }

    _showFirstServeDialog();
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final safeAreaPadding = mediaQuery.padding;
    final isLight = theme.brightness == Brightness.light;
    
    // Score styling
    final homeColor = _isHomeServing 
        ? (isLight ? Colors.orange.shade700 : Colors.yellow) 
        : (isLight ? Colors.black : Colors.white);
    final oppColor = !_isHomeServing 
        ? (isLight ? Colors.orange.shade700 : Colors.yellow) 
        : (isLight ? Colors.black : Colors.white);
    final scoreStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
    final setsStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);

    final homeName = widget.team.name;
    final oppName = widget.matchRoster?.rivalName ?? l10n.opponent;
    final homeInitials = widget.team.getInitials();
    final oppInitials = _getInitials(oppName);

    // Determine left and right team based on field orientation
    final leftInitials = _isHomeOnLeft ? homeInitials : oppInitials;
    final rightInitials = _isHomeOnLeft ? oppInitials : homeInitials;
    final leftScore = _isHomeOnLeft ? _homeScore : _opponentScore;
    final rightScore = _isHomeOnLeft ? _opponentScore : _homeScore;
    final leftColor = _isHomeOnLeft ? homeColor : oppColor;
    final rightColor = _isHomeOnLeft ? oppColor : homeColor;
    final leftAnimation = _isHomeOnLeft ? _homeScoreAnimation : _opponentScoreAnimation;
    final rightAnimation = _isHomeOnLeft ? _opponentScoreAnimation : _homeScoreAnimation;

    return Scaffold(
        appBar: AppBar(
        title: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                    Text('$leftInitials ', style: scoreStyle.copyWith(color: leftColor)),
                    AnimatedBuilder(
                      animation: leftAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: leftAnimation.value,
                          child: Text('$leftScore', style: scoreStyle.copyWith(color: leftColor)),
                        );
                      },
                    ),
                    Text(' - ', style: scoreStyle.copyWith(color: isLight ? Colors.black : Colors.white)),
                    AnimatedBuilder(
                      animation: rightAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: rightAnimation.value,
                          child: Text('$rightScore', style: scoreStyle.copyWith(color: rightColor)),
                        );
                      },
                    ),
                    Text(' $rightInitials', style: scoreStyle.copyWith(color: rightColor)),
                  ],
            ),
            Text(
              _isHomeOnLeft 
                  ? 'Sets: $_homeSets - $_opponentSets (Set $_currentSet)'
                  : 'Sets: $_opponentSets - $_homeSets (Set $_currentSet)',
              style: setsStyle,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _undoLastPoint,
            tooltip: l10n.undoLastPointTooltip,
          ),
          IconButton(
            icon: const Icon(Icons.copy_all),
            onPressed: _exportMatchLog,
            tooltip: l10n.exportMatchLogTooltip,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.resetMatch),
                  content: Text(l10n.resetMatchConfirmation),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _resetMatch();
                      },
                      child: Text(l10n.reset),
                    ),
                  ],
                ),
              );
            },
            tooltip: l10n.resetMatchTooltip,
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: _rotateField,
            tooltip: l10n.switchSidesTooltip,
          ),
          IconButton(
            icon: Icon(_isZoomed ? Icons.zoom_out : Icons.zoom_in),
            onPressed: () {
              setState(() {
                _isZoomed = !_isZoomed;
              });
            },
            tooltip: l10n.zoomTooltip,
          ),
          IconButton(
            icon: Icon(_showPlayerNumbers ? Icons.badge : Icons.person),
            onPressed: () {
              setState(() {
                _showPlayerNumbers = !_showPlayerNumbers;
              });
            },
            tooltip: _showPlayerNumbers ? l10n.showInitials : l10n.showNumbers,
          ),
          IconButton(
            icon: Icon(_isDrawingMode ? Icons.edit_off : Icons.edit),
            onPressed: () {
              setState(() {
                _isDrawingMode = !_isDrawingMode;
              });
            },
            tooltip: l10n.drawingModeTooltip,
          ),
          if (_isDrawingMode) ...[
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () => _controller.undo(),
              tooltip: l10n.undoTooltip,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _controller.clear(),
              tooltip: l10n.clearAllTooltip,
            ),
          ],
        ],
      ),
      body: Row(
        children: [
          // Left Controls
          Padding(
            padding: EdgeInsets.only(
              top: 8.0 + safeAreaPadding.top,
              bottom: 8.0 + safeAreaPadding.bottom,
              left: 8.0 + safeAreaPadding.left,
              right: 8.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isMatchSetupMode)
                   const SizedBox(width: 56)
                else ...[
                  Text(
                    'R${_isHomeOnLeft ? _homeRotation : _opponentRotation}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // ACE Button
                  FloatingActionButton.small(
                    heroTag: 'ace_left',
                    onPressed: () => _incrementScore(_isHomeOnLeft, isAce: true),
                    backgroundColor: Colors.orange,
                    tooltip: 'ACE',
                    child: const Icon(Icons.local_fire_department, color: Colors.white),
                  ),
                  const SizedBox(height: 8),

                  // Score Button (Primary)
                  GestureDetector(
                    onLongPress: () => _decrementScore(_isHomeOnLeft),
                    child: FloatingActionButton(
                      heroTag: 'score_left',
                      onPressed: () => _incrementScore(_isHomeOnLeft),
                      backgroundColor: _isHomeOnLeft ? Colors.blue : Colors.red,
                      child: const Icon(Icons.plus_one),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Rotate Button (Secondary)
                  GestureDetector(
                    onLongPress: () => _rotateSide(true, clockwise: false),
                    child: OutlinedButton(
                      onPressed: () => _rotateSide(true),
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(), 
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(Icons.rotate_right),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Removed text description
                ],
              ],
            ),
          ),
          
          // Court
          Expanded(
            child: FullCourtWidget(
              playerPositions: _playerPositions,
              players: _players,
              leftBench: _isHomeOnLeft ? _homeBench : _opponentBench,
              rightBench: _isHomeOnLeft ? _opponentBench : _homeBench,
              isZoomed: _isZoomed,
              isZoomedOnRight: !_isHomeOnLeft,
              isHomeOnLeft: _isHomeOnLeft,
              isDrawingMode: _isDrawingMode,
              showPlayerNumbers: _showPlayerNumbers,
              controller: _controller,
              frontRowPlayerIds: _playerLogicalPositions.entries
                  .where((e) => [2, 3, 4].contains(e.value))
                  .map((e) => e.key)
                  .toSet(),
              onPlayerMoved: _handlePlayerMoved,
              onPlayerTap: _handlePlayerTap,
              onBenchPlayerTap: _handleBenchPlayerTap,
              ballPosition: _ballPosition,
              onBallMoved: (newPos) {
                setState(() {
                  _ballPosition = newPos;
                });
                _saveMatchState();
              },
              homeTeamName: homeName,
              opponentTeamName: oppName,
            ),
          ),
          
          // Right Controls
          Padding(
            padding: EdgeInsets.only(
              top: 8.0 + safeAreaPadding.top,
              bottom: 8.0 + safeAreaPadding.bottom,
              left: 8.0,
              right: 8.0 + safeAreaPadding.right,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isMatchSetupMode)
                   FloatingActionButton.extended(
                     onPressed: _startMatchSetup,
                     label: Text(l10n.startMatch),
                     icon: const Icon(Icons.play_arrow),
                   )
                else ...[
                  Text(
                    'R${_isHomeOnLeft ? _opponentRotation : _homeRotation}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // ACE Button
                  FloatingActionButton.small(
                    heroTag: 'ace_right',
                    onPressed: () => _incrementScore(!_isHomeOnLeft, isAce: true),
                    backgroundColor: Colors.orange,
                    tooltip: 'ACE',
                    child: const Icon(Icons.local_fire_department, color: Colors.white),
                  ),
                  const SizedBox(height: 8),

                  // Score Button (Primary)
                  GestureDetector(
                    onLongPress: () => _decrementScore(!_isHomeOnLeft),
                    child: FloatingActionButton(
                      heroTag: 'score_right',
                      onPressed: () => _incrementScore(!_isHomeOnLeft),
                      backgroundColor: !_isHomeOnLeft ? Colors.blue : Colors.red,
                      child: const Icon(Icons.plus_one),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Rotate Button (Secondary)
                  GestureDetector(
                    onLongPress: () => _rotateSide(false, clockwise: false),
                    child: OutlinedButton(
                      onPressed: () => _rotateSide(false),
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(), 
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(Icons.rotate_right),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Removed text description
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
