import 'package:flutter/material.dart';
import '../../../teams/domain/models/player.dart';
import 'player_painter.dart';
import 'full_court_controller.dart';

class FullCourtWidget extends StatefulWidget {
  final Map<String, Offset> playerPositions; // Player ID -> Normalized Position (0.0-2.0, 0.0-1.0)
  final Map<String, Player> players; // Player ID -> Player object
  final List<Player> leftBench;
  final List<Player> rightBench;
  final bool isZoomed;
  final Function(String playerId, Offset newPosition) onPlayerMoved;
  final Function(String playerId) onPlayerTap;
  final Function(Player player, bool isLeftBench) onBenchPlayerTap;
  final bool isHomeOnLeft;
  final bool isDrawingMode;
  final bool showPlayerNumbers;
  final FullCourtController? controller;
  final Set<String> frontRowPlayerIds;
  final bool isZoomedOnRight;
  final Offset? ballPosition;
  final Function(Offset newPosition)? onBallMoved;
  final String? homeTeamName;
  final String? opponentTeamName;
  final bool showBench;
  final bool showGrid;
  final Map<String, Color>? roleColors; // Role ID -> Color (for role-based coloring)

  const FullCourtWidget({
    super.key,
    required this.playerPositions,
    required this.players,
    required this.leftBench,
    required this.rightBench,
    required this.isZoomed,
    required this.onPlayerMoved,
    required this.onPlayerTap,
    required this.onBenchPlayerTap,
    this.isHomeOnLeft = true,
    this.isDrawingMode = false,
    this.showPlayerNumbers = true,
    this.controller,
    this.frontRowPlayerIds = const {},
    this.isZoomedOnRight = false,
    this.ballPosition,
    this.onBallMoved,
    this.homeTeamName,
    this.opponentTeamName,
    this.showBench = true,
    this.showGrid = false,
    this.roleColors,
  });

  @override
  State<FullCourtWidget> createState() => _FullCourtWidgetState();
}

class _FullCourtWidgetState extends State<FullCourtWidget> {
  // Constants
  static const double _playerRadius = 28.0;
  static const double _playerSize = 56.0;
  static const double _ballRadius = 20.0; // Increased from 12.0 to 20.0
  static const double _ballSize = 40.0; // Size for icon
  static const double _benchHeightRatio = 0.15;
  static const double _touchThreshold = 0.15;
  static const Duration _animationDuration = Duration(milliseconds: 300);

  String? _draggedPlayerId;
  Offset _dragOffset = Offset.zero;
  bool _isDraggingBall = false;
  final List<List<Offset>> _drawingStrokes = [];
  List<Offset>? _currentStroke;

  @override
  void initState() {
    super.initState();
    widget.controller?.registerCallbacks(
      onUndo: undoLastStroke,
      onClear: clearAllDrawings,
    );
  }

  @override
  void didUpdateWidget(FullCourtWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      widget.controller?.registerCallbacks(
        onUndo: undoLastStroke,
        onClear: clearAllDrawings,
      );
    }
  }

  void undoLastStroke() {
    if (_drawingStrokes.isNotEmpty) {
      setState(() {
        _drawingStrokes.removeLast();
      });
    }
  }

  void clearAllDrawings() {
    setState(() {
      _drawingStrokes.clear();
      _currentStroke = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        // Calculate layout
        // Bench height: 15% of total height (only if showing bench)
        final benchHeight = widget.showBench ? availableHeight * 0.15 : 0.0;
        final courtAreaHeight = availableHeight - benchHeight;
        
        // Court aspect ratio: 
        // Full: 18x9 = 2:1
        // Zoomed: 9x9 = 1:1
        final targetRatio = widget.isZoomed ? 1.0 : 2.0;
        
        double courtWidth, courtHeight;
        
        if (availableWidth / courtAreaHeight > targetRatio) {
          // Height is limiting factor
          courtHeight = courtAreaHeight;
          courtWidth = courtHeight * targetRatio;
        } else {
          // Width is limiting factor
          courtWidth = availableWidth;
          courtHeight = courtWidth / targetRatio;
        }

        return Column(
          children: [
            // Main Court Area
            Expanded(
              child: Center(
                child: SizedBox(
                  width: courtWidth,
                  height: courtHeight,
                  child: GestureDetector(
                    onPanStart: (details) {
                      if (widget.isDrawingMode) {
                        // Start new drawing stroke
                        final localPos = details.localPosition;
                        setState(() {
                          _currentStroke = [localPos];
                        });
                      } else {
                        final localPos = details.localPosition;
                        final normalizedPos = _getNormalizedPosition(localPos, courtWidth, courtHeight);
                        
                        // Ball drag disabled - ball is now static
                        
                        final playerId = _findPlayerAt(normalizedPos);
                        if (playerId != null) {
                          setState(() {
                            _draggedPlayerId = playerId;
                            // Store the initial touch position relative to the player
                            final playerPos = widget.playerPositions[playerId]!;
                            final scaleX = courtWidth / (widget.isZoomed ? 1.0 : 2.0);
                            final scaleY = courtHeight;
                            final offsetX = widget.isZoomed && widget.isZoomedOnRight ? -1.0 * scaleX : 0.0;
                            final playerDrawX = playerPos.dx * scaleX + offsetX;
                            final playerDrawY = playerPos.dy * scaleY;
                            _dragOffset = Offset(localPos.dx - playerDrawX, localPos.dy - playerDrawY);
                          });
                        }
                      }
                    },
                    onPanUpdate: (details) {
                      if (widget.isDrawingMode) {
                        // Add point to current stroke
                        final localPos = details.localPosition;
                        setState(() {
                          _currentStroke?.add(localPos);
                        });
                      } else if (_draggedPlayerId != null) {
                        final localPos = details.localPosition;
                        // Calculate new position by subtracting the initial offset
                        final adjustedPos = Offset(
                          localPos.dx - _dragOffset.dx,
                          localPos.dy - _dragOffset.dy,
                        );
                        // Clamp to court boundaries
                        final clampedX = adjustedPos.dx.clamp(0.0, courtWidth);
                        final clampedY = adjustedPos.dy.clamp(0.0, courtHeight);
                        
                        final normalizedPos = _getNormalizedPosition(Offset(clampedX, clampedY), courtWidth, courtHeight);
                        widget.onPlayerMoved(_draggedPlayerId!, normalizedPos);
                      }
                    },
                    onPanEnd: (_) {
                      if (widget.isDrawingMode) {
                        // Finish current stroke
                        if (_currentStroke != null && _currentStroke!.isNotEmpty) {
                          setState(() {
                            _drawingStrokes.add(List.from(_currentStroke!));
                            _currentStroke = null;
                          });
                        }
                      } else {
                        setState(() {
                          _draggedPlayerId = null;
                          _dragOffset = Offset.zero;
                          _isDraggingBall = false; // Reset ball dragging state even if not used
                        });
                      }
                    },
                    onTapUp: (details) {
                      if (!widget.isDrawingMode) {
                        final localPos = details.localPosition;
                        final normalizedPos = _getNormalizedPosition(localPos, courtWidth, courtHeight);
                        final playerId = _findPlayerAt(normalizedPos);
                        if (playerId != null) {
                          widget.onPlayerTap(playerId);
                        }
                      }
                    },
                    child: Stack(
                      children: [
                        // Court background and lines
                        CustomPaint(
                          painter: FullCourtPainter(
                            playerPositions: widget.playerPositions,
                            players: widget.players,
                            isZoomed: widget.isZoomed,
                            isZoomedOnRight: widget.isZoomedOnRight,
                            isHomeOnLeft: widget.isHomeOnLeft,
                            courtColor: Colors.orange.shade100,
                            lineColor: Colors.white,
                            drawingStrokes: _drawingStrokes,
                            currentStroke: _currentStroke,
                            drawPlayers: false, // Don't draw players in painter
                            showGrid: widget.showGrid,
                            roleColors: widget.roleColors,
                          ),
                          size: Size(courtWidth, courtHeight), // Ensure CustomPaint takes full size
                        ),
                        
                        // Ball
                        if (widget.ballPosition != null) ...[
                          Builder(builder: (context) {
                             final pos = widget.ballPosition!;
                             // Skip if not visible in current zoom
                            if (widget.isZoomed) {
                              if (widget.isZoomedOnRight) {
                                if (pos.dx <= 1.0) return const SizedBox.shrink();
                              } else {
                                if (pos.dx > 1.0) return const SizedBox.shrink();
                              }
                            }
                            
                            final scaleX = courtWidth / (widget.isZoomed ? 1.0 : 2.0);
                            final scaleY = courtHeight;
                            final offsetX = widget.isZoomed && widget.isZoomedOnRight ? -1.0 * scaleX : 0.0;
                            
                            final drawX = pos.dx * scaleX + offsetX;
                            final drawY = pos.dy * scaleY;

                            return AnimatedPositioned(
                              duration: _isDraggingBall ? Duration.zero : _animationDuration,
                              curve: Curves.easeInOut,
                              left: drawX - _ballSize / 2,
                              top: drawY - _ballSize / 2,
                              child: Container(
                                width: _ballSize,
                                height: _ballSize,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.sports_volleyball,
                                  size: _ballSize * 0.8,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            );
                          }),
                        ],

                        // Animated players
                        ...widget.playerPositions.entries.map((entry) {
                          final id = entry.key;
                          final pos = entry.value;
                          
                          // Skip if not visible in current zoom
                          if (widget.isZoomed) {
                            if (widget.isZoomedOnRight) {
                              if (pos.dx <= 1.0) return const SizedBox.shrink();
                            } else {
                              if (pos.dx > 1.0) return const SizedBox.shrink();
                            }
                          }
                          
                          final scaleX = courtWidth / (widget.isZoomed ? 1.0 : 2.0);
                          final scaleY = courtHeight;
                          final offsetX = widget.isZoomed && widget.isZoomedOnRight ? -1.0 * scaleX : 0.0;
                          
                          final drawX = pos.dx * scaleX + offsetX;
                          final drawY = pos.dy * scaleY;
                          
                          final player = widget.players[id];
                          // For match mode (full_court_rotations_page), show initials/number based on showPlayerNumbers
                          // For rotation mode (modern_rotations_page), always show role abbreviation
                          final label = widget.roleColors != null 
                              ? (player?.name ?? '?') // Rotation mode: show role abbreviation
                              : (widget.showPlayerNumbers
                                  ? (player?.number?.toString() ?? player?.getInitials() ?? '?')
                                  : (player?.getInitials() ?? '?'));
                          
                          final isLeft = pos.dx <= 1.0;
                          final isHomeTeam = (widget.isHomeOnLeft && isLeft) || (!widget.isHomeOnLeft && !isLeft);
                          // Use role color if available, otherwise use team color
                          final color = widget.roleColors != null && widget.roleColors!.containsKey(id)
                              ? widget.roleColors![id]!
                              : (isHomeTeam ? Colors.blue : Colors.red);
                          
                          final isFrontRow = widget.frontRowPlayerIds.contains(id);
                          
                          final isDragging = id == _draggedPlayerId;

                          return AnimatedPositioned(
                            key: ValueKey(id),
                            duration: isDragging ? Duration.zero : _animationDuration,
                            curve: Curves.easeInOut,
                            left: drawX - _playerRadius,
                            top: drawY - _playerRadius,
                            child: AnimatedSwitcher(
                              duration: _animationDuration,
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return RotationTransition(
                                  turns: animation,
                                  child: ScaleTransition(scale: animation, child: child),
                                );
                              },
                              child: _buildPlayerWidget(
                                label, 
                                color, 
                                isFrontRow, 
                                pos.dx < 1.0,
                                key: ValueKey('$label-$color-$isFrontRow'),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Benches Area
            if (widget.showBench)
              SizedBox(
                height: benchHeight,
                child: Row(
                  children: [
                    // Left Bench (Home)
                    if (!widget.isZoomed || !widget.isZoomedOnRight)
                      Expanded(
                        child: Container(
                          color: widget.isHomeOnLeft ? Colors.blue.shade50 : Colors.red.shade50,
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.isHomeOnLeft 
                                  ? (widget.homeTeamName ?? 'Home Bench') 
                                  : (widget.opponentTeamName ?? 'Opponent Bench'), 
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)
                              ),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.leftBench.length,
                                  itemBuilder: (context, index) {
                                    final player = widget.leftBench[index];
                                    return GestureDetector(
                                      onTap: () => widget.onBenchPlayerTap(player, true),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: _buildBenchPlayerToken(player, widget.isHomeOnLeft ? Colors.blue : Colors.red),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Right Bench (Opponent)
                    if (!widget.isZoomed || widget.isZoomedOnRight)
                      Expanded(
                        child: Container(
                          color: widget.isHomeOnLeft ? Colors.red.shade50 : Colors.blue.shade50,
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.isHomeOnLeft 
                                  ? (widget.opponentTeamName ?? 'Opponent Bench') 
                                  : (widget.homeTeamName ?? 'Home Bench'), 
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)
                              ),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  itemCount: widget.rightBench.length,
                                  itemBuilder: (context, index) {
                                    final player = widget.rightBench[index];
                                    return GestureDetector(
                                      onTap: () => widget.onBenchPlayerTap(player, false),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: _buildBenchPlayerToken(player, widget.isHomeOnLeft ? Colors.red : Colors.blue),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPlayerWidget(String label, Color color, bool isFrontRow, bool isLeftSide, {Key? key}) {
    return SizedBox(
      key: key,
      width: _playerSize,
      height: _playerSize,
      child: CustomPaint(
        painter: PlayerPainter(
          label: label,
          color: color,
          isFrontRow: isFrontRow,
          isLeftSide: isLeftSide,
        ),
      ),
    );
  }

  Widget _buildBenchPlayerToken(Player player, Color color) {
    return AnimatedSwitcher(
      duration: _animationDuration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: CircleAvatar(
        key: ValueKey('${player.id}-$color-${widget.showPlayerNumbers}'),
        backgroundColor: color,
        radius: _playerRadius,
        child: Text(
          widget.showPlayerNumbers
              ? (player.number?.toString() ?? player.getInitials())
              : player.getInitials(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Offset _getNormalizedPosition(Offset localPos, double width, double height) {
    // If zoomed, we show 0.0-1.0 (Left side) or 1.0-2.0 (Right side)
    // If full, we show 0.0-2.0
    
    double scaleX = width / (widget.isZoomed ? 1.0 : 2.0);
    double x = localPos.dx / scaleX;
    
    if (widget.isZoomed && widget.isZoomedOnRight) {
      x += 1.0;
    }
    
    double y = localPos.dy / height;
    
    return Offset(x, y);
  }

  String? _findPlayerAt(Offset normalizedPos) {
    // Threshold for touch detection (in normalized units)
    // 0.1 in Y is 10% of court height (0.9m)
    // 0.1 in X is 5% of full court width (0.9m)
    
    for (final entry in widget.playerPositions.entries) {
      final pos = entry.value;
      // Simple distance check
      // Adjust X distance for aspect ratio difference if needed, but simple distance is fine for touch
      if ((pos - normalizedPos).distance < _touchThreshold) {
        return entry.key;
      }
    }
    return null;
  }
}

class FullCourtPainter extends CustomPainter {
  final Map<String, Offset> playerPositions;
  final Map<String, Player> players;
  final bool isZoomed;
  final bool isZoomedOnRight;
  final bool isHomeOnLeft;
  final Color courtColor;
  final Color lineColor;
  final List<List<Offset>> drawingStrokes;
  final List<Offset>? currentStroke;
  final bool drawPlayers;
  final bool showGrid;
  final Map<String, Color>? roleColors;

  FullCourtPainter({
    required this.playerPositions,
    required this.players,
    required this.isZoomed,
    this.isZoomedOnRight = false,
    required this.isHomeOnLeft,
    required this.courtColor,
    required this.lineColor,
    this.drawingStrokes = const [],
    this.currentStroke,
    this.drawPlayers = true,
    this.showGrid = false,
    this.roleColors,
  });
  
  // Helper function to get color for each player role
  Color _getRoleColor(String roleId) {
    if (roleColors != null && roleColors!.containsKey(roleId)) {
      return roleColors![roleId]!;
    }
    // Default colors by role
    switch (roleId) {
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
      case 'L':
        return Colors.red; // Libero - Red
      default:
        return Colors.grey;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw Court
    final paint = Paint()..color = courtColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Coordinate conversion
    // Full: X 0-2, Y 0-1
    // Zoomed: X 0-1, Y 0-1
    
    double scaleX = size.width / (isZoomed ? 1.0 : 2.0);
    double scaleY = size.height;
    
    // If zoomed, we show 0-1. Offset is 0.
    double offsetX = 0.0;
    if (isZoomed && isZoomedOnRight) {
      offsetX = -1.0 * scaleX;
    }

    void drawLine(double x1, double y1, double x2, double y2) {
      canvas.drawLine(
        Offset(x1 * scaleX + offsetX, y1 * scaleY),
        Offset(x2 * scaleX + offsetX, y2 * scaleY),
        linePaint,
      );
    }

    // Outer boundary (Full court 0-2)
    drawLine(0, 0, 2, 0); // Top
    drawLine(0, 1, 2, 1); // Bottom
    drawLine(0, 0, 0, 1); // Left
    drawLine(2, 0, 2, 1); // Right
    
    // Center line
    drawLine(1, 0, 1, 1);
    
    // Attack lines (3m from center)
    // Center is 1.0. 3m is 1/3 of 9m (0.33 units).
    drawLine(0.66, 0, 0.66, 1); // Left side attack line
    drawLine(1.33, 0, 1.33, 1); // Right side attack line

    // Draw grid if enabled - divide court into 6 positions (2 columns x 3 rows)
    if (showGrid) {
      // Positions layout (looking at net):
      // Front row: 4 (left), 3 (center), 2 (right)
      // Back row:  5 (left), 6 (center), 1 (right)
      //
      //   4    3    2
      //   5    6    1
      //
      // In normalized coordinates for one side (0.0-1.0):
      // X: 0.0 = back (left), 1.0 = front (right/near net)
      // Y: 0.0 = top, 0.33 = middle-top, 0.66 = middle-bottom, 1.0 = bottom
      
      final gridLinePaint = Paint()
        ..color = lineColor.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      
      void drawGridLine(double x1, double y1, double x2, double y2) {
        canvas.drawLine(
          Offset(x1 * scaleX + offsetX, y1 * scaleY),
          Offset(x2 * scaleX + offsetX, y2 * scaleY),
          gridLinePaint,
        );
      }
      
      // Vertical line to divide into 2 columns (back, front)
      drawGridLine(0.5, 0, 0.5, 1); // Back/Front divider
      
      // Horizontal lines to divide into 3 rows (top, middle, bottom)
      drawGridLine(0, 0.33, 1, 0.33); // Top/Middle divider
      drawGridLine(0, 0.66, 1, 0.66); // Middle/Bottom divider
      
      // Draw position numbers (1-6)
      final textStyle = TextStyle(
        color: lineColor.withValues(alpha: 0.7),
        fontSize: size.height * 0.08,
        fontWeight: FontWeight.bold,
      );
      
      void drawPositionNumber(String number, double x, double y, {bool isRightSide = false}) {
        final textSpan = TextSpan(text: number, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          textAlign: isRightSide ? TextAlign.right : TextAlign.left,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        // Position numbers on the right side of the zone for left side, left side for right side
        // Calculate zone boundaries - each zone is half the court width (0.0-1.0 for one side)
        // x is the center of the zone (0.25 for left column, 0.75 for right column)
        // zoneWidth is half of one side = 0.5 in normalized coordinates
        final zoneWidth = 0.5 * scaleX; // Half of one side in pixels
        final padding = size.width * 0.08; // Padding from the edge
        // Position at right edge of zone for left side, left edge for right side
        // For left column (x=0.25): right edge is at 0.25 + 0.25 = 0.5
        // For right column (x=0.75): right edge is at 0.75 + 0.25 = 1.0
        final zoneEdge = x * scaleX + offsetX + (isRightSide ? -zoneWidth / 2 : zoneWidth / 2);
        final paintX = isRightSide 
            ? zoneEdge + padding // Left side of zone for right side
            : zoneEdge - padding; // Right side of zone for left side
        textPainter.paint(
          canvas,
          Offset(paintX - (isRightSide ? textPainter.width : 0), y * scaleY - textPainter.height / 2),
        );
      }
      
      // Layout with 2 columns (back/front) and 3 rows (top/middle/bottom):
      // Top:     [5] [4]
      // Middle:  [6] [3]
      // Bottom:  [1] [2]
      //
      // Column left (back): 5 (top), 6 (middle), 1 (bottom)
      // Column right (front): 4 (top), 3 (middle), 2 (bottom)
      //
      // With 2 columns: left (back) at x=0.25, right (front) at x=0.75
      // With 3 rows: top at y=0.17, middle at y=0.5, bottom at y=0.83
      
      // Position 1: Back right (bottom, left column)
      drawPositionNumber('1', 0.25, 0.83);
      // Position 2: Front right (bottom, right column)
      drawPositionNumber('2', 0.75, 0.83);
      // Position 3: Front center (middle, right column)
      drawPositionNumber('3', 0.75, 0.5);
      // Position 4: Front left (top, right column)
      drawPositionNumber('4', 0.75, 0.17);
      // Position 5: Back left (top, left column)
      drawPositionNumber('5', 0.25, 0.17);
      // Position 6: Back center (middle, left column)
      drawPositionNumber('6', 0.25, 0.5);
      
      // Also draw for right side if showing full court
      if (!isZoomed || isZoomedOnRight) {
        drawGridLine(1.5, 0, 1.5, 1); // Back/Front divider (right side)
        drawGridLine(1, 0.33, 2, 0.33); // Top/Middle divider (right side)
        drawGridLine(1, 0.66, 2, 0.66); // Middle/Bottom divider (right side)
        
        // Position numbers for right side (inverted layout - viewing from other side)
        // Layout inverted:
        // Top:     [2] [1]
        // Middle:  [3] [6]
        // Bottom:  [4] [5]
        //
        // Column left (front for them): 2 (top), 3 (middle), 4 (bottom)
        // Column right (back for them): 1 (top), 6 (middle), 5 (bottom)
        // Numbers should be on the LEFT side of zones for right side
        drawPositionNumber('1', 1.75, 0.17, isRightSide: true); // Top right (back for them)
        drawPositionNumber('2', 1.25, 0.17, isRightSide: true); // Top left (front for them)
        drawPositionNumber('3', 1.25, 0.5, isRightSide: true);  // Middle left (front for them)
        drawPositionNumber('4', 1.25, 0.83, isRightSide: true); // Bottom left (front for them)
        drawPositionNumber('5', 1.75, 0.83, isRightSide: true); // Bottom right (back for them)
        drawPositionNumber('6', 1.75, 0.5, isRightSide: true);  // Middle right (back for them)
      }
    }

    // Net (at Center line)
    final netPaint = Paint()
      ..color = Colors.red.withOpacity(0.5)
      ..strokeWidth = 4.0;
      
    canvas.drawLine(
      Offset(1.0 * scaleX + offsetX, 0),
      Offset(1.0 * scaleX + offsetX, size.height),
      netPaint,
    );

    // Draw Players with animation
    if (drawPlayers) {
      final playerWidgets = <Widget>[];
      playerPositions.forEach((id, pos) {
      // Check if visible
      if (isZoomed && pos.dx > 1.0) return;
      
      final drawX = pos.dx * scaleX + offsetX;
      final drawY = pos.dy * scaleY;
      
      // Determine color - use role color if available, otherwise use team color
      final isLeft = pos.dx <= 1.0;
      final isHomeTeam = (isHomeOnLeft && isLeft) || (!isHomeOnLeft && !isLeft);
      final color = roleColors != null ? _getRoleColor(id) : (isHomeTeam ? Colors.blue : Colors.red);
      
      final player = players[id];
      // For match mode (full_court_rotations_page), show initials/number based on showPlayerNumbers
      // For rotation mode (modern_rotations_page), always show role abbreviation
      final label = roleColors != null 
          ? (player?.name ?? '?') // Rotation mode: show role abbreviation
          : (player?.number?.toString() ?? player?.getInitials() ?? '?');
      
      // Draw Player Shape (With Volume)
      final center = Offset(drawX, drawY);
      final path = Path();
      const radius = 28.0;

      // Check if in Front Zone (Attack Line to Net)
      final isFrontRow = (pos.dx > 0.66 && pos.dx < 1.0) || (pos.dx > 1.0 && pos.dx < 1.33);

      if (isFrontRow) {
        // Draw Triangle pointing toward net
        final isLeftSide = pos.dx < 1.0;
        
        if (isLeftSide) {
          // Point right
          path.moveTo(center.dx + radius, center.dy); // Right point
          path.lineTo(center.dx - radius, center.dy - radius); // Top left
          path.lineTo(center.dx - radius, center.dy + radius); // Bottom left
        } else {
          // Point left
          path.moveTo(center.dx - radius, center.dy); // Left point
          path.lineTo(center.dx + radius, center.dy - radius); // Top right
          path.lineTo(center.dx + radius, center.dy + radius); // Bottom right
        }
        path.close();
      } else {
        // Draw Circle
        path.addOval(Rect.fromCircle(center: center, radius: radius));
      }
      
      // Draw Shadow
      canvas.drawShadow(path, Colors.black, 6.0, true);
      
      // Draw Gradient Fill (3D Effect)
      final gradient = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          Color.lerp(color, Colors.white, 0.3)!, 
          color, 
          Color.lerp(color, Colors.black, 0.2)!,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
      
      final shapePaint = Paint()..shader = gradient;
      canvas.drawPath(path, shapePaint);
      
      // Draw Border
      final borderPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawPath(path, borderPaint);
      
      // Draw Label
      final textSpan = TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white, 
          fontSize: 16, 
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black54),
          ]
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
        Offset(drawX - textPainter.width / 2, drawY - textPainter.height / 2),
      );
    });
    }
    
    // Draw drawing strokes
    final drawingPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    // Draw completed strokes
    for (final stroke in drawingStrokes) {
      if (stroke.length > 1) {
        final path = Path();
        path.moveTo(stroke.first.dx, stroke.first.dy);
        for (int i = 1; i < stroke.length; i++) {
          path.lineTo(stroke[i].dx, stroke[i].dy);
        }
        canvas.drawPath(path, drawingPaint);
      }
    }
    
    // Draw current stroke
    if (currentStroke != null && currentStroke!.length > 1) {
      final path = Path();
      path.moveTo(currentStroke!.first.dx, currentStroke!.first.dy);
      for (int i = 1; i < currentStroke!.length; i++) {
        path.lineTo(currentStroke![i].dx, currentStroke![i].dy);
      }
      canvas.drawPath(path, drawingPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
