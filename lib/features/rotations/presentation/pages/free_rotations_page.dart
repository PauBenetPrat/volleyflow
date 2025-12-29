import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../teams/domain/models/team.dart';
import '../../../teams/domain/models/player.dart';
import '../widgets/full_court_widget.dart';
import '../widgets/full_court_controller.dart';
import 'package:volleyball_coaching_app/l10n/app_localizations.dart';

class FreeRotationsPage extends ConsumerStatefulWidget {
  final Team? team;

  const FreeRotationsPage({
    super.key,
    this.team,
  });

  @override
  ConsumerState<FreeRotationsPage> createState() => _FreeRotationsPageState();
}

class _FreeRotationsPageState extends ConsumerState<FreeRotationsPage> with WidgetsBindingObserver, TickerProviderStateMixin {
  // State
  final Map<String, Offset> _playerPositions = {}; // ID -> Position
  final Map<String, Player> _players = {}; // ID -> Player
  final Map<String, int> _playerLogicalPositions = {}; // ID -> Logical Position (1-6)
  final List<Player> _leftBench = [];
  final List<Player> _rightBench = [];
  bool _isZoomed = false;
  bool _isLeftOnLeft = true;
  int _leftRotation = 1;
  int _rightRotation = 1;
  bool _isDrawingMode = false;
  bool _showPlayerNumbers = true; // Default to showing numbers
  final FullCourtController _controller = FullCourtController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Force landscape orientation for better court visualization
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePlayers();
      _checkOrientation();
    });
  }

  @override
  void dispose() {
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

  void _checkOrientation() {
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;
    
    // In portrait, enable zoom by default (though we force landscape)
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

  void _initializePlayers() {
    _playerPositions.clear();
    _players.clear();
    _playerLogicalPositions.clear();
    _leftBench.clear();
    _rightBench.clear();

    // Initialize Left Side with 6 numbered players (1-6)
    final leftPositions = _getStandardPositions(true);
    for (int i = 0; i < 6; i++) {
      final playerId = 'left_$i';
      final player = Player(
        id: playerId,
        name: 'Player ${i + 1}',
        number: i + 1,
      );
      _players[playerId] = player;
      _playerPositions[playerId] = leftPositions[i];
      _playerLogicalPositions[playerId] = i + 1;
    }

    // Initialize Right Side with 6 numbered players (1-6)
    final rightPositions = _getStandardPositions(false);
    for (int i = 0; i < 6; i++) {
      final playerId = 'right_$i';
      final player = Player(
        id: playerId,
        name: 'Player ${i + 1}',
        number: i + 1,
      );
      _players[playerId] = player;
      _playerPositions[playerId] = rightPositions[i];
      _playerLogicalPositions[playerId] = i + 1;
    }
    
    setState(() {});
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

  void _handlePlayerMoved(String playerId, Offset newPosition) {
    if (!_isDrawingMode) {
      setState(() {
        _playerPositions[playerId] = newPosition;
      });
    }
  }

  void _handlePlayerTap(String playerId) {
    // In FREE mode, tapping a player could allow editing the number
    // For now, we'll just show a snackbar
    final player = _players[playerId];
    if (player != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Player ${player.number}')),
      );
    }
  }

  void _handleBenchPlayerTap(Player player, bool isLeftBench) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Player: ${player.name}')),
    );
  }

  void _resetPositions(bool isLeft) {
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
    setState(() {});
  }

  void _rotateSide(bool isLeft, {bool clockwise = true}) {
    // Update rotation number
    setState(() {
      if (isLeft) {
        if (clockwise) {
          _leftRotation = (_leftRotation % 6) + 1;
        } else {
          _leftRotation = (_leftRotation - 2 + 6) % 6 + 1;
        }
      } else {
        if (clockwise) {
          _rightRotation = (_rightRotation % 6) + 1;
        } else {
          _rightRotation = (_rightRotation - 2 + 6) % 6 + 1;
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
      _resetPositions(isLeft);
    });
  }

  void _rotateField() {
    setState(() {
      _isLeftOnLeft = !_isLeftOnLeft;
      
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
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final safeAreaPadding = mediaQuery.padding;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rotationSystemFree),
        centerTitle: true,
        actions: [
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
                Text(
                  'R$_leftRotation',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // Rotate Button
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
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _resetPositions(true),
                  child: Text(l10n.reset),
                ),
              ],
            ),
          ),
          
          // Court
          Expanded(
            child: FullCourtWidget(
              playerPositions: _playerPositions,
              players: _players,
              leftBench: _leftBench,
              rightBench: _rightBench,
              isZoomed: _isZoomed,
              isZoomedOnRight: !_isLeftOnLeft,
              isHomeOnLeft: _isLeftOnLeft,
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
              homeTeamName: widget.team?.name ?? 'Team 1',
              opponentTeamName: 'Opponent',
              showBench: false,
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
                Text(
                  'R$_rightRotation',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // Rotate Button
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
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _resetPositions(false),
                  child: Text(l10n.reset),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

