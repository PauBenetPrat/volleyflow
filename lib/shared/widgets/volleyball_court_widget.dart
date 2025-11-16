import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/rotation_positions.dart';
import '../../core/constants/rotation_validator.dart';
import '../../features/rotations/domain/providers/rotation_provider.dart';

class VolleyballCourtWidget extends ConsumerStatefulWidget {
  final List<String> playerPositions;
  final int? rotation; // If provided, use specific coordinates
  final Phase? phase; // If provided, use specific coordinates
  final Color? courtColor;
  final Color? lineColor;
  final Color? playerCircleColor;
  final RotationValidationResult? validationResult; // Resultat de validació

  const VolleyballCourtWidget({
    super.key,
    required this.playerPositions,
    this.rotation,
    this.phase,
    this.courtColor,
    this.lineColor,
    this.playerCircleColor,
    this.validationResult,
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
  DateTime? _lastValidationTime;
  static const _validationThrottleMs = 100; // Validar màxim cada 100ms durant el drag

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
                  
                  // Throttle validation during drag to avoid flickering
                  final now = DateTime.now();
                  final shouldValidate = _lastValidationTime == null ||
                      now.difference(_lastValidationTime!).inMilliseconds >= _validationThrottleMs;
                  
                  if (shouldValidate) {
                    ref.read(rotationProvider.notifier).updatePlayerPosition(
                      _draggedPlayer!,
                      newPosition,
                    );
                    _lastValidationTime = now;
                  } else {
                    // Update position without validation to keep smooth dragging
                    ref.read(rotationProvider.notifier).updatePlayerPositionWithoutValidation(
                      _draggedPlayer!,
                      newPosition,
                    );
                  }
                }
              },
              onPanEnd: (details) {
                // Always validate one final time when drag ends
                if (_draggedPlayer != null) {
                  final rotationState = ref.read(rotationProvider);
                  if (rotationState.customPositions != null && 
                      rotationState.customPositions!.containsKey(_draggedPlayer)) {
                    final finalPosition = rotationState.customPositions![_draggedPlayer]!;
                    ref.read(rotationProvider.notifier).updatePlayerPosition(
                      _draggedPlayer!,
                      finalPosition,
                    );
                  }
                }
                
                setState(() {
                  _draggedPlayer = null;
                  _dragOffset = null;
                  _lastValidationTime = null;
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
                        validationResult: widget.validationResult,
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
  final RotationValidationResult? validationResult; // Resultat de validació
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
    this.validationResult,
    required this.courtColor,
    required this.lineColor,
    required this.playerColor,
  });
  
  // Extreu els noms dels jugadors que estan en falta dels errors
  Set<String> _getPlayersInViolation() {
    final playersInViolation = <String>{};
    if (validationResult != null && !validationResult!.isValid) {
      // Llista de possibles noms de jugadors
      const playerRoles = ['Co', 'C1', 'C2', 'R1', 'R2', 'O'];
      
      for (final error in validationResult!.errors) {
        // Buscar tots els noms de jugadors que apareixen a l'error
        for (final role in playerRoles) {
          // Buscar el nom del jugador seguit de parèntesi o espai o final de línia
          final regex = RegExp('\\b$role\\b');
          if (regex.hasMatch(error)) {
            playersInViolation.add(role);
          }
        }
      }
    }
    return playersInViolation;
  }

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
        for (int i = 0; i < previousPositions!.length && i < CourtPosition.allPositions.length; i++) {
          final role = previousPositions![i];
          if (role.isNotEmpty) {
            // Use standard position mapping for previous
            final position = CourtPosition.allPositions[i];
            final stdCoords = PositionCoord.fromStandardPosition(position);
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
      
      for (int i = 0; i < playerPositions.length && i < positionCoordinates.length && i < CourtPosition.allPositions.length; i++) {
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
    
    // Obtenir jugadors en violació
    final playersInViolation = _getPlayersInViolation();
    
    // Determinar quins jugadors són davanters segons la posició BASE
    final frontRowPlayers = <String>{};
    if (rotation != null) {
      final basePositions = RotationPositions.getPositionCoords(rotation!, Phase.base);
      for (final entry in basePositions.entries) {
        final playerRole = entry.key;
        final baseCoord = entry.value;
        
        // Trobar la posició estàndard més propera
        int closestPos = CourtPosition.position1;
        double minDist = double.infinity;
        for (final pos in CourtPosition.allPositions) {
          final stdCoord = PositionCoord.fromStandardPosition(pos);
          final dist = (baseCoord.x - stdCoord.x).abs() + (baseCoord.y - stdCoord.y).abs();
          if (dist < minDist) {
            minDist = dist;
            closestPos = pos;
          }
        }
        
        if (CourtPosition.isFrontRow(closestPos)) {
          frontRowPlayers.add(playerRole);
        }
      }
    }
    
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
      
      // Check if this player is in violation
      final isInViolation = playersInViolation.contains(playerRole);
      
      // Check if this player is in front row
      final isFrontRow = frontRowPlayers.contains(playerRole);
      
      // Get color for this player role
      final roleColor = getRoleColor(playerRole);
      
      // Use role color, with reduced opacity for secondary players
      // If in violation, use red color
      final shapePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isInViolation
            ? Colors.red.withValues(alpha: 0.8)
            : (isSecondary 
                ? roleColor.withValues(alpha: 0.7) // Lighter/dimmer for secondary
                : roleColor);
      
      // Draw triangle for front row players, circle for back row players
      if (isFrontRow) {
        // Draw triangle pointing up (towards net)
        final trianglePath = Path();
        final triangleSize = playerRadius * 1.2;
        trianglePath.moveTo(currentPosition.dx, currentPosition.dy - triangleSize); // Top point
        trianglePath.lineTo(currentPosition.dx - triangleSize, currentPosition.dy + triangleSize * 0.5); // Bottom left
        trianglePath.lineTo(currentPosition.dx + triangleSize, currentPosition.dy + triangleSize * 0.5); // Bottom right
        trianglePath.close();
        
        canvas.drawPath(trianglePath, shapePaint);
        
        // Draw border for secondary players or players in violation
        if (isSecondary || isInViolation) {
          final borderPaint = Paint()
            ..style = PaintingStyle.stroke
            ..color = isInViolation ? Colors.red : roleColor
            ..strokeWidth = isInViolation ? 3.0 : 2.0;
          canvas.drawPath(trianglePath, borderPaint);
        }
      } else {
        // Draw circle for back row players
        canvas.drawCircle(currentPosition, playerRadius, shapePaint);
        
        // Draw border for secondary players or players in violation
        if (isSecondary || isInViolation) {
          final borderPaint = Paint()
            ..style = PaintingStyle.stroke
            ..color = isInViolation ? Colors.red : roleColor
            ..strokeWidth = isInViolation ? 3.0 : 2.0;
          canvas.drawCircle(currentPosition, playerRadius, borderPaint);
        }
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
        oldDelegate.validationResult != validationResult ||
        oldDelegate.courtColor != courtColor ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.playerColor != playerColor;
  }
}

