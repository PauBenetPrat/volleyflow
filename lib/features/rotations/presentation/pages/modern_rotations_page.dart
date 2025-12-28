import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/providers/rotation_provider.dart';
import '../../../../core/constants/rotation_positions_5_1_no_libero.dart';
import '../../../../core/constants/rotation_positions_5_1.dart' as rotation_51;
import '../../../../core/constants/rotation_validator.dart';
import '../../../../core/constants/player_roles.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/full_court_widget.dart';
import '../widgets/full_court_controller.dart';
import '../../../teams/domain/models/player.dart';

/// Nova pàgina modernitzada per a rotacions 5-1 i 5-1 no libero
/// Combina la visualització de full_court amb les fases i validació de posicions
class ModernRotationsPage extends ConsumerStatefulWidget {
  final String? rotationSystem; // '5-1' or '5-1-no-libero'
  
  const ModernRotationsPage({
    super.key,
    this.rotationSystem,
  });

  @override
  ConsumerState<ModernRotationsPage> createState() => _ModernRotationsPageState();
}

class _ModernRotationsPageState extends ConsumerState<ModernRotationsPage> 
    with WidgetsBindingObserver, TickerProviderStateMixin {
  
  // Rotation state
  int _currentRotation = 1;
  Phase _currentPhase = Phase.base;
  final Map<String, PositionCoord> _customPositions = {}; // Role -> PositionCoord
  RotationValidationResult? _validationResult;
  
  // UI state
  bool _isZoomed = false;
  bool _isDrawingMode = false;
  bool _showPlayerNumbers = true;
  bool _showGrid = false;
  final FullCourtController _controller = FullCourtController();
  
  // Player data - map roles to player info
  final Map<String, String> _roleToPlayerName = {}; // Role -> Player name
  final Map<String, int?> _roleToPlayerNumber = {}; // Role -> Player number
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Force landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    // Initialize rotation system
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final system = widget.rotationSystem ?? '5-1-no-libero';
      ref.read(rotationProvider.notifier).setRotationSystem(system);
      _initializePlayers();
      _validatePositions();
      _checkFirstTime();
    });
  }
  
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  void _initializePlayers() {
    // Initialize default player names/numbers for each role
    final roles = PlayerRole.allRoles;
    for (final role in roles) {
      _roleToPlayerName[role] = PlayerRole.getDisplayAbbreviation(role, AppLocalizations.of(context));
      _roleToPlayerNumber[role] = null;
    }
    setState(() {});
  }
  
  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownHelp = prefs.getBool('has_shown_modern_rotations_help') ?? false;
    if (!hasShownHelp && mounted) {
      _showHelpDialog(context, AppLocalizations.of(context)!);
    }
  }

  void _showHelpDialog(BuildContext context, AppLocalizations l10n) {
    bool dontShowAgain = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.helpTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.helpMovePlayers),
                  const SizedBox(height: 8),
                  Text(l10n.helpPlayerInfo),
                  const SizedBox(height: 8),
                  Text(l10n.helpRotate),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: dontShowAgain,
                        onChanged: (value) {
                          setState(() {
                            dontShowAgain = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(l10n.dontShowAgain),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (dontShowAgain) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('has_shown_modern_rotations_help', true);
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(l10n.ok),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  // Convert role-based positions to FullCourtWidget format
  Map<String, Offset> _getPlayerPositionsForCourt() {
    final system = widget.rotationSystem ?? '5-1-no-libero';
    final baseCoords = system == '5-1'
        ? _getPositionCoords51(_currentRotation, _currentPhase)
        : RotationPositions51NoLibero.getPositionCoords(_currentRotation, _currentPhase);
    
    // Merge custom positions
    final coords = Map<String, PositionCoord>.from(baseCoords);
    coords.addAll(_customPositions);
    
    // Convert to Offset format for FullCourtWidget
    // FullCourtWidget uses normalized coordinates 0.0-2.0 for X (left side is 0.0-1.0)
    // We'll place all players on the left side (0.0-1.0)
    // PositionCoord uses: x=0.0 is back, x=1.0 is front (near net)
    // FullCourtWidget left side: x=0.0 is left edge, x=1.0 is center line
    final positions = <String, Offset>{};
    coords.forEach((role, coord) {
      // Only include players on court (y <= 1.0)
      if (coord.y <= 1.0) {
        // Map from PositionCoord (0.0-1.0) to FullCourtWidget left side (0.0-1.0)
        // PositionCoord x: 0.0=back, 1.0=front -> FullCourtWidget: 0.0=back, 1.0=front
        positions[role] = Offset(coord.x, coord.y);
      }
    });
    
    return positions;
  }
  
  // Calculate which players are in front row based on their BASE position (not current position)
  Set<String> _getFrontRowPlayerIds() {
    final frontRowIds = <String>{};
    final system = widget.rotationSystem ?? '5-1-no-libero';
    
    // Get BASE positions (not current phase positions)
    final baseCoords = system == '5-1'
        ? _getPositionCoords51(_currentRotation, Phase.base)
        : RotationPositions51NoLibero.getPositionCoords(_currentRotation, Phase.base);
    
    // Check each player's BASE position to determine if they're in front row
    baseCoords.forEach((role, coord) {
      // Front row positions are 2, 3, 4
      // In PositionCoord system, front row typically has x > 0.5 (closer to net)
      // But we need to check the actual position number
      // Positions 2, 3, 4 are front row (x around 0.75-0.8)
      // Positions 1, 5, 6 are back row (x around 0.25-0.3)
      if (coord.x > 0.6) { // Front row threshold
        frontRowIds.add(role);
      }
    });
    
    return frontRowIds;
  }
  
  Map<String, Player> _getPlayersForCourt() {
    final players = <String, Player>{};
    final system = widget.rotationSystem ?? '5-1-no-libero';
    final l10n = AppLocalizations.of(context)!;
    
    // Get roles based on rotation system
    // For 5-1 system, include libero; for 5-1-no-libero, exclude libero
    final roles = system == '5-1' 
        ? PlayerRole.allRoles 
        : PlayerRole.allRoles.where((role) => role != PlayerRole.libero).toList();
    
    for (final role in roles) {
      // Use role abbreviation (2-3 letters) as name
      final roleAbbr = PlayerRole.getDisplayAbbreviation(role, l10n);
      final number = _roleToPlayerNumber[role];
      players[role] = Player(
        id: role,
        name: roleAbbr.isNotEmpty ? roleAbbr : '?', // This will be displayed (MB1, MB2, OH1, OH2, S, OP, L)
        number: number,
      );
    }
    
    return players;
  }
  
  // Get role colors map
  Map<String, Color> _getRoleColors() {
    return {
      'Co': Colors.blue,   // Setter (Colocador) - Blue
      'C1': Colors.green,   // Middle Blocker 1 (Central) - Green
      'C2': Colors.green,   // Middle Blocker 2 (Central) - Green
      'O': Colors.purple,   // Opposite (Opuesto) - Purple
      'R1': Colors.orange,  // Outside Hitter 1 (Receptor) - Orange
      'R2': Colors.orange,  // Outside Hitter 2 (Receptor) - Orange
      'L': Colors.red,      // Libero - Red
    };
  }
  
  // Helper to get position coords for 5-1 system
  Map<String, PositionCoord> _getPositionCoords51(int rotation, Phase phase) {
    return rotation_51.RotationPositions51.getPositionCoords(rotation, phase);
  }
  
  void _validatePositions() {
    if (_currentPhase == Phase.base || _currentPhase == Phase.recepcio) {
      final system = widget.rotationSystem ?? '5-1-no-libero';
      final baseCoords = system == '5-1'
          ? _getPositionCoords51(_currentRotation, _currentPhase)
          : RotationPositions51NoLibero.getPositionCoords(_currentRotation, _currentPhase);
      
      final allPositions = Map<String, PositionCoord>.from(baseCoords);
      allPositions.addAll(_customPositions);
      
      _validationResult = RotationValidator.validateReceptionPositions(
        _currentRotation,
        allPositions,
        rotationSystem: system,
      );
    } else {
      _validationResult = null;
    }
    setState(() {});
  }
  
  void _handlePlayerMoved(String playerId, Offset newPosition) {
    if (!_isDrawingMode) {
      setState(() {
        // FullCourtWidget already gives us normalized coordinates (0.0-1.0 for left side)
        // These map directly to PositionCoord (0.0-1.0)
        _customPositions[playerId] = PositionCoord(
          x: newPosition.dx.clamp(0.0, 1.0),
          y: newPosition.dy.clamp(0.0, 1.0),
        );
      });
      _validatePositions();
    }
  }
  
  void _handlePlayerTap(String playerId) {
    // Show player info dialog
    final l10n = AppLocalizations.of(context)!;
    final roleName = PlayerRole.getDisplayAbbreviation(playerId, l10n);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(roleName),
        content: Text('Role: $playerId'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
  
  void _rotateClockwise() {
    setState(() {
      _currentRotation = _currentRotation <= 1 ? 6 : _currentRotation - 1;
      _customPositions.clear(); // Reset custom positions on rotation change
    });
    _validatePositions();
  }
  
  void _rotateCounterClockwise() {
    setState(() {
      _currentRotation = _currentRotation >= 6 ? 1 : _currentRotation + 1;
      _customPositions.clear();
    });
    _validatePositions();
  }
  
  void _setPhase(Phase phase) {
    setState(() {
      // Toggle: if clicking same phase, go back to base
      _currentPhase = (_currentPhase == phase) ? Phase.base : phase;
      _customPositions.clear(); // Reset custom positions on phase change
    });
    _validatePositions();
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final safeAreaPadding = mediaQuery.padding;
    
    final playerPositions = _getPlayerPositionsForCourt();
    final players = _getPlayersForCourt();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('R$_currentRotation - ${_getPhaseName(_currentPhase, l10n)}'),
        centerTitle: true,
        actions: [
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
          IconButton(
            icon: Icon(_showGrid ? Icons.grid_on : Icons.grid_off),
            onPressed: () {
              setState(() {
                _showGrid = !_showGrid;
              });
            },
            tooltip: _showGrid ? 'Hide Grid' : 'Show Grid',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showHelpDialog(context, AppLocalizations.of(context)!);
            },
            tooltip: l10n.helpTitle,
          ),
        ],
      ),
      body: Row(
        children: [
          // Left panel - Phase buttons and rotation
          Container(
            width: 120,
            padding: EdgeInsets.only(
              top: 8.0 + safeAreaPadding.top,
              bottom: 8.0 + safeAreaPadding.bottom,
              left: 8.0 + safeAreaPadding.left,
              right: 8.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Phase buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _setPhase(Phase.sac),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentPhase == Phase.sac
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    child: Text(
                      l10n.sac,
                      style: TextStyle(
                        color: _currentPhase == Phase.sac
                            ? Colors.white
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _setPhase(Phase.recepcio),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentPhase == Phase.recepcio
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    child: Text(
                      l10n.recepcio,
                      style: TextStyle(
                        color: _currentPhase == Phase.recepcio
                            ? Colors.white
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _setPhase(Phase.defensa),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentPhase == Phase.defensa
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    child: Text(
                      l10n.defensa,
                      style: TextStyle(
                        color: _currentPhase == Phase.defensa
                            ? Colors.white
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Rotation button
                GestureDetector(
                  onDoubleTap: _rotateCounterClockwise,
                  child: OutlinedButton(
                    onPressed: _rotateClockwise,
                    style: OutlinedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(Icons.rotate_right),
                  ),
                ),
              ],
            ),
          ),
          
          // Court area
          Expanded(
            child: Stack(
              children: [
                FullCourtWidget(
                  playerPositions: playerPositions,
                  players: players,
                  leftBench: const [],
                  rightBench: const [],
                  isZoomed: _isZoomed,
                  isZoomedOnRight: false,
                  isHomeOnLeft: true,
                  isDrawingMode: _isDrawingMode,
                  showPlayerNumbers: _showPlayerNumbers,
                  controller: _controller,
                  frontRowPlayerIds: _getFrontRowPlayerIds(),
                  onPlayerMoved: _handlePlayerMoved,
                  onPlayerTap: _handlePlayerTap,
                  onBenchPlayerTap: (player, isLeft) {},
                  showBench: false,
                  showGrid: _showGrid,
                  roleColors: _getRoleColors(),
                ),
                
                // Validation errors overlay
                if (_validationResult != null && !_validationResult!.isValid)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.rotationValidationError,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _validationResult = null;
                                    });
                                  },
                                  tooltip: l10n.close,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ..._validationResult!.errors.map((error) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '• $error',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getPhaseName(Phase phase, AppLocalizations l10n) {
    switch (phase) {
      case Phase.base:
        return l10n.base;
      case Phase.sac:
        return l10n.sac;
      case Phase.recepcio:
        return l10n.recepcio;
      case Phase.defensa:
        return l10n.defensa;
    }
  }
}

