import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../teams/domain/models/team.dart';
import '../../../teams/domain/models/player.dart';
import '../widgets/full_court_widget.dart';
import '../widgets/player_swap_dialog.dart';

import '../widgets/full_court_controller.dart';

class FullCourtRotationsPage extends StatefulWidget {
  final Team team;

  const FullCourtRotationsPage({
    super.key,
    required this.team,
  });

  @override
  State<FullCourtRotationsPage> createState() => _FullCourtRotationsPageState();
}

class _FullCourtRotationsPageState extends State<FullCourtRotationsPage> with WidgetsBindingObserver {
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
  final FullCourtController _controller = FullCourtController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _initializePlayers();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartingLineupDialog();
      _checkOrientation();
    });
  }

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

    // 1. Get roster
    final roster = widget.team.players.toList();
    final startingLineup = starters ?? roster.take(6).toList();
    
    // Add ALL players to the map to ensure they can be rendered
    for (final player in roster) {
      _players[player.id] = player;
    }
    
    // 2. Place first 6 on Left Side (Home) in 4-2 formation
    final startingPositions = [
      Offset(0.3, 0.8), // 1 (Back Right)
      Offset(0.8, 0.8), // 2 (Front Right)
      Offset(0.8, 0.5), // 3 (Front Center)
      Offset(0.8, 0.2), // 4 (Front Left)
      Offset(0.3, 0.2), // 5 (Back Left)
      Offset(0.3, 0.5), // 6 (Back Center)
    ];

    // Add starters
    for (int i = 0; i < startingLineup.length; i++) {
      final player = startingLineup[i];
      if (i < 6) {
        _playerPositions[player.id] = startingPositions[i];
        _playerLogicalPositions[player.id] = i + 1;
      }
    }

    // Add remaining to bench
    for (final player in roster) {
      if (!startingLineup.contains(player)) {
        _homeBench.add(player);
      }
    }

    // 3. Create 6 Ghost Players for Right Side (Opponent)
    final opponentPositions = [
      Offset(1.7, 0.8), // 1 (Back Left - Mirrored?)
      Offset(1.2, 0.8), // 2
      Offset(1.2, 0.5), // 3
      Offset(1.2, 0.2), // 4
      Offset(1.7, 0.2), // 5
      Offset(1.7, 0.5), // 6
    ];

    for (int i = 0; i < 6; i++) {
      final ghostId = 'ghost_$i';
      final ghostPlayer = Player(
        id: ghostId,
        name: 'Opponent',
        number: i + 1,
      );
      _players[ghostId] = ghostPlayer;
      _playerPositions[ghostId] = opponentPositions[i];
      _playerLogicalPositions[ghostId] = i + 1;
    }
    
    setState(() {});
  }

  void _handlePlayerMoved(String playerId, Offset newPosition) {
    if (!_isDrawingMode) {
      setState(() {
        _playerPositions[playerId] = newPosition;
      });
    }
  }

  void _handlePlayerTap(String playerId) async {
    // Only allow swapping real players (not ghosts)
    if (playerId.startsWith('ghost_')) return;

    final player = _players[playerId];
    if (player == null) return;

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
          _homeBench.add(player);
        }
      });
    }
  }

  void _handleBenchPlayerTap(Player player, bool isLeftBench) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Player: ${player.name}')),
    );
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

    final centerX = isLeft ? 0.5 : 1.5;
    final centerY = 0.5;

    // Sort players by angle to establish a cycle
    sidePlayers.sort((a, b) {
      final angleA = (a.value - Offset(centerX, centerY)).direction;
      final angleB = (b.value - Offset(centerX, centerY)).direction;
      return angleA.compareTo(angleB);
    });

    final positions = sidePlayers.map((e) => e.value).toList();
    
    // Animate the rotation with a smoother transition
    await Future.delayed(const Duration(milliseconds: 100));
    
    setState(() {
      if (clockwise) {
        for (int i = 0; i < sidePlayers.length; i++) {
          final nextIndex = (i + 1) % sidePlayers.length;
          _playerPositions[sidePlayers[i].key] = positions[nextIndex];
          
          // Update logical position: 1->6->5->4->3->2->1
          final currentLogical = _playerLogicalPositions[sidePlayers[i].key];
          if (currentLogical != null) {
            _playerLogicalPositions[sidePlayers[i].key] = currentLogical == 1 ? 6 : currentLogical - 1;
          }
        }
      } else {
        for (int i = 0; i < sidePlayers.length; i++) {
          final prevIndex = (i - 1 + sidePlayers.length) % sidePlayers.length;
          _playerPositions[sidePlayers[i].key] = positions[prevIndex];
          
          // Update logical position: 1->2->3->4->5->6->1
          final currentLogical = _playerLogicalPositions[sidePlayers[i].key];
          if (currentLogical != null) {
            _playerLogicalPositions[sidePlayers[i].key] = currentLogical == 6 ? 1 : currentLogical + 1;
          }
        }
      }
    });
  }

  void _rotateField() {
    setState(() {
      _isHomeOnLeft = !_isHomeOnLeft;
      
      final newPositions = <String, Offset>{};
      _playerPositions.forEach((id, pos) {
        double newX;
        if (pos.dx < 1.0) {
          newX = pos.dx + 1.0;
        } else {
          newX = pos.dx - 1.0;
        }
        newPositions[id] = Offset(newX, pos.dy);
      });
      _playerPositions.clear();
      _playerPositions.addAll(newPositions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.team.name} - Full Court'),
        actions: _isDrawingMode
            ? [
                // Drawing mode actions
                IconButton(
                  icon: const Icon(Icons.undo),
                  onPressed: () {
                    _controller.undo();
                  },
                  tooltip: 'Undo',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _controller.clear();
                  },
                  tooltip: 'Clear All',
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isDrawingMode = false;
                    });
                    _controller.clear();
                  },
                  tooltip: 'Exit Drawing Mode',
                ),
              ]
            : [
                // Normal mode actions
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isDrawingMode = true;
                    });
                  },
                  tooltip: 'Drawing Mode',
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
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: _rotateField,
                  tooltip: 'Switch Sides',
                ),
              ],
      ),
      body: Center(
        child: Row(
        children: [
          // Left Controls
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isHomeOnLeft ? 'Home' : 'Opponent',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'R${_isHomeOnLeft ? _homeRotation : _opponentRotation}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'rotate_left_ccw',
                      onPressed: () => _rotateSide(true, clockwise: false),
                      backgroundColor: _isHomeOnLeft ? Colors.blue.shade100 : Colors.red.shade100,
                      child: Icon(Icons.rotate_left, color: _isHomeOnLeft ? Colors.blue : Colors.red),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: 'rotate_left_cw',
                      onPressed: () => _rotateSide(true, clockwise: true),
                      backgroundColor: _isHomeOnLeft ? Colors.blue : Colors.red,
                      child: const Icon(Icons.rotate_right),
                    ),
                  ],
                ),
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
                controller: _controller,
                frontRowPlayerIds: _playerLogicalPositions.entries
                    .where((e) => [2, 3, 4].contains(e.value))
                    .map((e) => e.key)
                    .toSet(),
                onPlayerMoved: _handlePlayerMoved,
                onPlayerTap: _handlePlayerTap,
                onBenchPlayerTap: _handleBenchPlayerTap,
              ),
            ),
          
          // Right Controls
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  !_isHomeOnLeft ? 'Home' : 'Opponent',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'R${!_isHomeOnLeft ? _homeRotation : _opponentRotation}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'rotate_right_ccw',
                      onPressed: () => _rotateSide(false, clockwise: false),
                      backgroundColor: !_isHomeOnLeft ? Colors.blue.shade100 : Colors.red.shade100,
                      child: Icon(Icons.rotate_left, color: !_isHomeOnLeft ? Colors.blue : Colors.red),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: 'rotate_right_cw',
                      onPressed: () => _rotateSide(false, clockwise: true),
                      backgroundColor: !_isHomeOnLeft ? Colors.blue : Colors.red,
                      child: const Icon(Icons.rotate_right),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
