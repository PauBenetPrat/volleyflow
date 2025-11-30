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

import '../widgets/full_court_controller.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';

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

class _FullCourtRotationsPageState extends ConsumerState<FullCourtRotationsPage> with WidgetsBindingObserver {
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
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Starting 6'),
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
                  child: const Text('Start'),
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      if (_isHomeServing) {
        // Home is serving
        if (_isHomeOnLeft) {
          // Home on left side
          _ballPosition = const Offset(0.05, 0.9);
        } else {
          // Home on right side
          _ballPosition = const Offset(1.95, 0.1);
        }
      } else {
        // Opponent is serving (opposite side of home)
        if (_isHomeOnLeft) {
          // Opponent on right side
          _ballPosition = const Offset(1.95, 0.1);
        } else {
          // Opponent on left side
          _ballPosition = const Offset(0.05, 0.9);
        }
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
    final numberController = TextEditingController(
      text: player.number?.toString() ?? '',
    );

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Opponent Player Number'),
        content: TextField(
          controller: numberController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Player Number',
            hintText: 'Enter number (1-99)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final number = int.tryParse(numberController.text);
              if (number != null && number >= 1 && number <= 99) {
                Navigator.pop(context, number);
              }
            },
            child: const Text('Save'),
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMatchState();
      _checkOrientation();
    });
  }

  void _loadMatchState() {
    final savedState = ref.read(matchStateProvider);
    
    if (savedState != null && savedState.matchRoster?.id == widget.matchRoster?.id) {
      // Restore state from provider
      setState(() {
        // Clear and restore maps/lists
        _playerPositions.clear();
        _playerPositions.addAll(
          savedState.playerPositions.map((k, v) => MapEntry(k, Offset(v.dx, v.dy)))
        );
        _players.clear();
        _players.addAll(savedState.players);
        _playerLogicalPositions.clear();
        _playerLogicalPositions.addAll(savedState.playerLogicalPositions);
        _homeBench.clear();
        _homeBench.addAll(savedState.homeBench);
        _opponentBench.clear();
        _opponentBench.addAll(savedState.opponentBench);
        
        // Restore scores and match state
        _homeScore = savedState.homeScore;
        _opponentScore = savedState.opponentScore;
        _homeSets = savedState.homeSets;
        _opponentSets = savedState.opponentSets;
        _currentSet = savedState.currentSet;
        _isHomeServing = savedState.isHomeServing;
        _ballPosition = savedState.ballPosition != null 
            ? Offset(savedState.ballPosition!.dx, savedState.ballPosition!.dy)
            : const Offset(0.05, 0.9);
        _matchStarted = savedState.matchStarted;
        _isMatchSetupMode = savedState.isMatchSetupMode;
        _firstServerOfSet = savedState.firstServerOfSet;
        _homeRotation = savedState.homeRotation;
        _opponentRotation = savedState.opponentRotation;
        
        // Restore opponent player numbers
        for (final entry in savedState.opponentPlayerNumbers.entries) {
          final ghostId = entry.key;
          final number = entry.value;
          if (_players.containsKey(ghostId)) {
            _players[ghostId] = _players[ghostId]!.copyWith(number: number);
          }
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
    final currentState = MatchState(
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

  void _incrementScore(bool isHome) {
    setState(() {
      if (isHome) {
        _homeScore++;
        if (!_isHomeServing) {
          // Sideout: Home wins serve
          _isHomeServing = true;
          _rotateSide(true, clockwise: true); // Rotate Home
          _updateBallPositionForServe();
        }
      } else {
        _opponentScore++;
        if (_isHomeServing) {
          // Sideout: Opponent wins serve
          _isHomeServing = false;
          _rotateSide(false, clockwise: true); // Rotate Opponent
          _updateBallPositionForServe();
        }
      }
      _checkSetWin();
    });
  }

  void _showFirstServeDialog() {
    final homeName = widget.team.name;
    final oppName = widget.matchRoster?.rivalName ?? 'Opponent';
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Who Serves First?'),
        content: const Text('Select the team that serves first.'),
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

  void _showSetWinDialog(bool homeWon) {
    final l10n = AppLocalizations.of(context)!;
    final homeName = widget.team.name;
    final oppName = widget.matchRoster?.rivalName ?? 'Opponent';
    final winner = homeWon ? homeName : oppName;
    
    // Check Match Win
    if (_homeSets == 3 || _opponentSets == 3) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('$winner Wins Match!'),
          content: Text('Final Score: $_homeSets - $_opponentSets'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetMatch();
              },
              child: const Text('New Match'),
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
              child: const Text('Next Set'),
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
      _initializePlayers(); // Reset players to bench/placeholders
      _updateBallPositionForServe();
      // Note: matchRoster is kept in memory - it's part of widget state
      // Only cleared when navigating away or starting a new match
    });
    _saveMatchState();
  }

  void _startMatchSetup() {
    // Validate 6 players
    final homePlayersOnCourt = _playerPositions.keys
        .where((id) => !id.startsWith('ghost_') && !id.startsWith('placeholder_'))
        .length;
        
    if (homePlayersOnCourt < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please place 6 players on the court to start.')),
      );
      return;
    }

    _showFirstServeDialog();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
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
    final oppName = widget.matchRoster?.rivalName ?? 'Opponent';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: _isHomeOnLeft 
                ? [
                    Text('$homeName $_homeScore', style: scoreStyle.copyWith(color: homeColor)),
                    Text(' - ', style: scoreStyle.copyWith(color: isLight ? Colors.black : Colors.white)),
                    Text('$_opponentScore $oppName', style: scoreStyle.copyWith(color: oppColor)),
                  ]
                : [
                    Text('$oppName $_opponentScore', style: scoreStyle.copyWith(color: oppColor)),
                    Text(' - ', style: scoreStyle.copyWith(color: isLight ? Colors.black : Colors.white)),
                    Text('$_homeScore $homeName', style: scoreStyle.copyWith(color: homeColor)),
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
            icon: const Icon(Icons.refresh),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Match?'),
                  content: const Text('This will reset scores, sets, and player positions. Are you sure?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _resetMatch();
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Reset Match',
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: _rotateField,
            tooltip: 'Switch Sides',
          ),
          IconButton(
            icon: Icon(_isZoomed ? Icons.zoom_out : Icons.zoom_in),
            onPressed: () {
              setState(() {
                _isZoomed = !_isZoomed;
              });
            },
            tooltip: 'Zoom',
          ),
          IconButton(
            icon: Icon(_showPlayerNumbers ? Icons.badge : Icons.person),
            onPressed: () {
              setState(() {
                _showPlayerNumbers = !_showPlayerNumbers;
              });
            },
            tooltip: _showPlayerNumbers ? 'Show Initials' : 'Show Numbers',
          ),
          IconButton(
            icon: Icon(_isDrawingMode ? Icons.edit_off : Icons.edit),
            onPressed: () {
              setState(() {
                _isDrawingMode = !_isDrawingMode;
              });
            },
            tooltip: 'Drawing Mode',
          ),
          if (_isDrawingMode) ...[
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () => _controller.undo(),
              tooltip: 'Undo',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _controller.clear(),
              tooltip: 'Clear All',
            ),
          ],
        ],
      ),
      body: Row(
        children: [
          // Left Controls
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isMatchSetupMode)
                   const SizedBox(width: 56)
                else ...[
                  Text(
                    _isHomeOnLeft ? homeName : oppName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'R${_isHomeOnLeft ? _homeRotation : _opponentRotation}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
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
                  Text(_isHomeOnLeft ? '$homeName Rot' : '$oppName Rot', style: const TextStyle(fontSize: 10)),
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
            ),
          ),
          
          // Right Controls
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                    _isHomeOnLeft ? oppName : homeName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'R${_isHomeOnLeft ? _opponentRotation : _homeRotation}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
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
                  Text(!_isHomeOnLeft ? '$homeName Rot' : '$oppName Rot', style: const TextStyle(fontSize: 10)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
