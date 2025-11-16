import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/rotation_positions.dart';
import '../../features/rotations/domain/providers/rotation_provider.dart';

class VolleyballCourtWidget extends ConsumerStatefulWidget {
  final List<String> playerPositions;
  final int? rotation; // If provided, use specific coordinates
  final Phase? phase; // If provided, use specific coordinates
  final Color? courtColor;
  final Color? lineColor;
  final Color? playerCircleColor;

  const VolleyballCourtWidget({
    super.key,
    required this.playerPositions,
    this.rotation,
    this.phase,
    this.courtColor,
    this.lineColor,
    this.playerCircleColor,
  });

  @override
  ConsumerState<VolleyballCourtWidget> createState() => _VolleyballCourtWidgetState();
}

class _VolleyballCourtWidgetState extends ConsumerState<VolleyballCourtWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<String> _previousPositions = [];
  List<String> _currentPositions = [];
  String? _draggedPlayer;
  Offset? _dragOffset;

  @override
  void initState() {
    super.initState();
    _currentPositions = List<String>.from(widget.playerPositions);
    _previousPositions = List<String>.from(widget.playerPositions);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  String? _getPlayerAtPosition(Offset position, Size size, Map<String, PositionCoord>? customPositions) {
    if (widget.rotation == null || widget.phase == null) return null;
    
    final baseCoords = RotationPositions.getPositionCoords(
      widget.rotation!,
      widget.phase!,
    );
    
    // Merge custom positions with base positions
    final coords = Map<String, PositionCoord>.from(baseCoords);
    if (customPositions != null) {
      customPositions.forEach((role, customCoord) {
        coords[role] = customCoord;
      });
    }
    
    final playerRadius = size.height * 0.06;
    
    for (final entry in coords.entries) {
      final playerPos = Offset(
        entry.value.x * size.width,
        entry.value.y * size.height,
      );
      
      final distance = (position - playerPos).distance;
      if (distance <= playerRadius * 1.5) {
        return entry.key;
      }
    }
    
    return null;
  }

  @override
  void didUpdateWidget(VolleyballCourtWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.playerPositions != widget.playerPositions ||
        oldWidget.rotation != widget.rotation ||
        oldWidget.phase != widget.phase) {
      _previousPositions = List<String>.from(_currentPositions);
      _currentPositions = List<String>.from(widget.playerPositions);
      // Only animate if rotation or phase changed (not for drag & drop)
      if (oldWidget.rotation != widget.rotation || oldWidget.phase != widget.phase) {
        _animationController.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final courtBgColor = widget.courtColor ?? theme.colorScheme.surface;
    final linesColor = widget.lineColor ?? theme.colorScheme.outline;
    final playerColor = widget.playerCircleColor ?? theme.colorScheme.primary;
    
    // Watch provider to rebuild when customPositions change
    final rotationState = ref.watch(rotationProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use available space, maintaining aspect ratio
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;
        
        // Court aspect ratio: 9m x 9m = 1:1 (single half court)
        const courtAspectRatio = 1.0;
        
        double courtWidth;
        double courtHeight;
        
        if (availableWidth / availableHeight > courtAspectRatio) {
          // Height is the limiting factor
          courtHeight = availableHeight;
          courtWidth = courtHeight * courtAspectRatio;
        } else {
          // Width is the limiting factor
          courtWidth = availableWidth;
          courtHeight = courtWidth / courtAspectRatio;
        }

        return Center(
          child: SizedBox(
            width: courtWidth,
            height: courtHeight,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (details) {
                final localPosition = details.localPosition;
                final player = _getPlayerAtPosition(
                  localPosition, 
                  Size(courtWidth, courtHeight),
                  rotationState.customPositions,
                );
                if (player != null) {
                  setState(() {
                    _draggedPlayer = player;
                    _dragOffset = localPosition;
                  });
                }
              },
              onPanUpdate: (details) {
                if (_draggedPlayer != null) {
                  // Update player position in provider
                  final newX = (details.localPosition.dx / courtWidth).clamp(0.0, 1.0);
                  final newY = (details.localPosition.dy / courtHeight).clamp(0.0, 1.0);
                  final newPosition = PositionCoord(x: newX, y: newY);
                  
                  ref.read(rotationProvider.notifier).updatePlayerPosition(
                    _draggedPlayer!,
                    newPosition,
                  );
                }
              },
              onPanEnd: (details) {
                setState(() {
                  _draggedPlayer = null;
                  _dragOffset = null;
                });
              },
              child: Container(
                color: Colors.transparent,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    // Watch provider inside AnimatedBuilder to ensure rebuild when customPositions change
                    final currentRotationState = ref.watch(rotationProvider);
                    return CustomPaint(
                      size: Size(courtWidth, courtHeight),
                      painter: VolleyballCourtPainter(
                        playerPositions: _currentPositions,
                        previousPositions: _previousPositions,
                        animationValue: _animation.value,
                        rotation: widget.rotation,
                        phase: widget.phase,
                        customPositions: currentRotationState.customPositions,
                        courtColor: courtBgColor,
                        lineColor: linesColor,
                        playerColor: playerColor,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class VolleyballCourtPainter extends CustomPainter {
  final List<String> playerPositions;
  final List<String>? previousPositions;
  final double animationValue;
  final int? rotation; // If provided, use specific coordinates
  final Phase? phase; // If provided, use specific coordinates
  final Map<String, PositionCoord>? customPositions; // Override positions for drag & drop
  final Color courtColor;
  final Color lineColor;
  final Color playerColor;

  VolleyballCourtPainter({
    required this.playerPositions,
    this.previousPositions,
    this.animationValue = 1.0,
    this.rotation,
    this.phase,
    this.customPositions,
    required this.courtColor,
    required this.lineColor,
    required this.playerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = courtColor;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = lineColor
      ..strokeWidth = 2.0;

    // Draw court background
    final courtRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(courtRect, paint);

    // Draw outer border
    canvas.drawRect(courtRect, linePaint);

    // Draw net line (front line - at the right edge, net is at the front)
    final netLineX = size.width; // Right edge (net is at the front)
    final netPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red // Red color for net to make it visible
      ..strokeWidth = 3.0;
    canvas.drawLine(
      Offset(netLineX, 0),
      Offset(netLineX, size.height),
      netPaint,
    );
    
    // Draw net label
    final netTextSpan = TextSpan(
      text: 'NET',
      style: TextStyle(
        color: Colors.red,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
    final netTextPainter = TextPainter(
      text: netTextSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    netTextPainter.layout();
    netTextPainter.paint(
      canvas,
      Offset(
        netLineX - netTextPainter.width - 5,
        size.height / 2 - netTextPainter.height / 2,
      ),
    );

    // Draw attack line (3m from net/front line)
    // Court is 9m wide, so 3m from front = 3/9 = 1/3 of court width
    final attackLineDistance = size.width / 3; // 3m out of 9m court
    final attackLineX = size.width - attackLineDistance;
    canvas.drawLine(
      Offset(attackLineX, 0),
      Offset(attackLineX, size.height),
      linePaint,
    );

    // Draw player positions on the court
    // Volleyball positions layout (9m x 9m court):
    // Rotated 90 degrees: 2 columns of 3 players
    // Left column: positions 4, 3, 2 (top to bottom)
    // Right column: positions 5, 6, 1 (top to bottom)
    
    final playerRadius = size.height * 0.06;

    // Helper function to get color for each player role
    Color getRoleColor(String role) {
      switch (role) {
        case 'Co':
          return Colors.blue; // Setter (Colocador) - Blue
        case 'C1':
        case 'C2':
          return Colors.green; // Middle Blocker (Central) - Green
        case 'O':
          return Colors.purple; // Opposite (Opuesto) - Purple
        case 'R1':
        case 'R2':
          return Colors.orange; // Outside Hitter (Receptor) - Orange
        default:
          return Colors.white;
      }
    }

    // Position coordinates relative to the court (9m x 9m)
    // Net is at the RIGHT edge (size.width)
    // Front (prop de la xarxa) = RIGHT side (high X values)
    // Back (lluny de la xarxa) = LEFT side (low X values)
    // Front row (davant, prop de la xarxa): positions 2, 3, 4
    // Back row (darrere, lluny de la xarxa): positions 1, 6, 5
    
    // X positions: left (back), center, right (front/near net)
    final leftX = size.width * 0.25;   // Back (lluny de la xarxa)
    final centerX = size.width * 0.5;
    final rightX = size.width * 0.75;  // Front (prop de la xarxa)
    
    // Y positions: top, middle, bottom (left to right across court)
    final topY = size.height * 0.25;
    final middleY = size.height * 0.5;
    final bottomY = size.height * 0.75;

    // Get player coordinates - use specific coordinates if rotation and phase are provided
    Map<String, Offset> playerCoords = {};
    Map<String, Offset>? previousPlayerCoords;
    
    if (rotation != null && phase != null) {
      // Use specific coordinates from RotationPositions
      final baseCoords = RotationPositions.getPositionCoords(rotation!, phase!);
      
      // Merge custom positions with base positions
      // If a player has a custom position, use it; otherwise use base position
      final coords = Map<String, PositionCoord>.from(baseCoords);
      if (customPositions != null) {
        customPositions!.forEach((role, customCoord) {
          coords[role] = customCoord;
        });
      }
      
      coords.forEach((role, coord) {
        playerCoords[role] = Offset(
          coord.x * size.width,  // x: 0.0 = back, 1.0 = front
          coord.y * size.height, // y: 0.0 = top, 1.0 = bottom
        );
      });
      
      // Get previous coordinates if available
      if (previousPositions != null && animationValue < 1.0) {
        // Try to get previous rotation/phase from context (simplified - would need to pass this)
        // For now, use standard positions for previous
        previousPlayerCoords = {};
        for (int i = 0; i < previousPositions!.length; i++) {
          final role = previousPositions![i];
          if (role.isNotEmpty) {
            // Use standard position mapping for previous
            final stdCoords = PositionCoord.fromStandardPosition(i + 1);
            previousPlayerCoords![role] = Offset(
              stdCoords.x * size.width,
              stdCoords.y * size.height,
            );
          }
        }
      }
    } else {
      // Fallback to standard positions
      final positionCoordinates = [
        Offset(leftX, bottomY),   // Position 1: back right
        Offset(rightX, bottomY),  // Position 2: front right
        Offset(rightX, middleY), // Position 3: front center
        Offset(rightX, topY),    // Position 4: front left
        Offset(leftX, topY),     // Position 5: back left
        Offset(leftX, middleY),  // Position 6: back center
      ];
      
      for (int i = 0; i < playerPositions.length && i < positionCoordinates.length; i++) {
        final role = playerPositions[i];
        if (role.isNotEmpty) {
          playerCoords[role] = positionCoordinates[i];
        }
      }
    }

    // Draw players based on current positions with animation
    // If we have specific coordinates, draw all roles from coords
    // Otherwise, draw from playerPositions list
    final rolesToDraw = rotation != null && phase != null
        ? playerCoords.keys.toList()
        : playerPositions.where((role) => role.isNotEmpty).toList();
    
    for (final playerRole in rolesToDraw) {
      if (playerRole.isEmpty || !playerCoords.containsKey(playerRole)) continue;
      
      // Find where this player was in previous positions
      Offset? previousPosition;
      if (previousPlayerCoords != null && animationValue < 1.0) {
        previousPosition = previousPlayerCoords[playerRole];
      }
      
      // Calculate animated position
      final targetPosition = playerCoords[playerRole]!;
      final currentPosition = previousPosition != null && animationValue < 1.0
          ? Offset.lerp(previousPosition, targetPosition, animationValue)!
          : targetPosition;
      
      // Determine if this is a secondary player (C2 or R2)
      final isSecondary = playerRole == 'C2' || playerRole == 'R2';
      
      // Get color for this player role
      final roleColor = getRoleColor(playerRole);
      
      // Use role color for circle, with reduced opacity for secondary players
      final circlePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isSecondary 
            ? roleColor.withValues(alpha: 0.7) // Lighter/dimmer for secondary
            : roleColor;
      
      // Draw circle with role-specific color at animated position
      canvas.drawCircle(currentPosition, playerRadius, circlePaint);
      
      // Draw border for secondary players to distinguish them
      if (isSecondary) {
        final borderPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = roleColor
          ..strokeWidth = 2.0;
        canvas.drawCircle(currentPosition, playerRadius, borderPaint);
      }
      
      // Draw player role with smaller text and contrasting white color
      final textSpan = TextSpan(
        text: playerRole,
        style: TextStyle(
          color: Colors.white, // Contrasting white text
          fontSize: playerRadius * 0.9, // Smaller text
          fontWeight: isSecondary ? FontWeight.w600 : FontWeight.bold,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          currentPosition.dx - textPainter.width / 2,
          currentPosition.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(VolleyballCourtPainter oldDelegate) {
    return oldDelegate.playerPositions != playerPositions ||
        oldDelegate.previousPositions != previousPositions ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.rotation != rotation ||
        oldDelegate.phase != phase ||
        oldDelegate.customPositions != customPositions ||
        oldDelegate.courtColor != courtColor ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.playerColor != playerColor;
  }
}

