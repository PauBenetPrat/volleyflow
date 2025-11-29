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
  final FullCourtController? controller;
  final Set<String> frontRowPlayerIds;

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
    this.controller,
    this.frontRowPlayerIds = const {},
  });

  @override
  State<FullCourtWidget> createState() => _FullCourtWidgetState();
}

class _FullCourtWidgetState extends State<FullCourtWidget> {
  // Constants
  static const double _playerRadius = 20.0;
  static const double _playerSize = 40.0;
  static const double _benchHeightRatio = 0.15;
  static const double _touchThreshold = 0.15;
  static const Duration _animationDuration = Duration(milliseconds: 300);

  String? _draggedPlayerId;
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
        // Bench height: 15% of total height
        final benchHeight = availableHeight * 0.15;
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
                        final playerId = _findPlayerAt(normalizedPos);
                        if (playerId != null) {
                          setState(() {
                            _draggedPlayerId = playerId;
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
                        // Clamp to court boundaries
                        final clampedX = localPos.dx.clamp(0.0, courtWidth);
                        final clampedY = localPos.dy.clamp(0.0, courtHeight);
                        
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
                            isHomeOnLeft: widget.isHomeOnLeft,
                            courtColor: Colors.orange.shade100,
                            lineColor: Colors.white,
                            drawingStrokes: _drawingStrokes,
                            currentStroke: _currentStroke,
                            drawPlayers: false, // Don't draw players in painter
                          ),
                          size: Size(courtWidth, courtHeight), // Ensure CustomPaint takes full size
                        ),
                        // Animated players
                        ...widget.playerPositions.entries.map((entry) {
                          final id = entry.key;
                          final pos = entry.value;
                          
                          // Skip if zoomed and on right side
                          if (widget.isZoomed && pos.dx > 1.0) {
                            return const SizedBox.shrink();
                          }
                          
                          final scaleX = courtWidth / (widget.isZoomed ? 1.0 : 2.0);
                          final scaleY = courtHeight;
                          final offsetX = 0.0;
                          
                          final drawX = pos.dx * scaleX + offsetX;
                          final drawY = pos.dy * scaleY;
                          
                          final player = widget.players[id];
                          final label = player?.number?.toString() ?? player?.getInitials() ?? '?';
                          
                          final isLeft = pos.dx <= 1.0;
                          final isHomeTeam = (widget.isHomeOnLeft && isLeft) || (!widget.isHomeOnLeft && !isLeft);
                          final color = isHomeTeam ? Colors.blue : Colors.red;
                          
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
            SizedBox(
              height: benchHeight,
              child: Row(
                children: [
                  // Left Bench (Home)
                  Expanded(
                    child: Container(
                      color: widget.isHomeOnLeft ? Colors.blue.shade50 : Colors.red.shade50,
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.isHomeOnLeft ? 'Home Bench' : 'Opponent Bench', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
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
                  Expanded(
                    child: Container(
                      color: widget.isHomeOnLeft ? Colors.red.shade50 : Colors.blue.shade50,
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(widget.isHomeOnLeft ? 'Opponent Bench' : 'Home Bench', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
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
        key: ValueKey('${player.id}-$color'),
        backgroundColor: color,
        radius: _playerRadius,
        child: Text(
          player.number?.toString() ?? player.getInitials(),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  Offset _getNormalizedPosition(Offset localPos, double width, double height) {
    // If zoomed, we show 0.0-1.0 (Left side)
    // If full, we show 0.0-2.0
    
    double x = localPos.dx / (width / (widget.isZoomed ? 1.0 : 2.0));
    double y = localPos.dy / height;
    
    // If zoomed, we are viewing the left half (0.0-1.0)
    // Wait, user said "zoom in and just show the half interesting field".
    // Usually this means the active side. For now let's assume Left side is active.
    
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
  final bool isHomeOnLeft;
  final Color courtColor;
  final Color lineColor;
  final List<List<Offset>> drawingStrokes;
  final List<Offset>? currentStroke;
  final bool drawPlayers;

  FullCourtPainter({
    required this.playerPositions,
    required this.players,
    required this.isZoomed,
    required this.isHomeOnLeft,
    required this.courtColor,
    required this.lineColor,
    this.drawingStrokes = const [],
    this.currentStroke,
    this.drawPlayers = true,
  });

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
      
      // Determine color based on side
      final isLeft = pos.dx <= 1.0;
      final isHomeTeam = (isHomeOnLeft && isLeft) || (!isHomeOnLeft && !isLeft);
      final color = isHomeTeam ? Colors.blue : Colors.red;
      
      final player = players[id];
      final label = player?.number?.toString() ?? player?.getInitials() ?? '?';
      
      // Draw Player Shape
      final playerPaint = Paint()..color = color;
      
      // Check if in Front Zone (Attack Line to Net)
      final isFrontRow = (pos.dx > 0.66 && pos.dx < 1.0) || (pos.dx > 1.0 && pos.dx < 1.33);
      
      if (isFrontRow) {
        // Draw Triangle pointing toward net
        final path = Path();
        final isLeftSide = pos.dx < 1.0;
        
        if (isLeftSide) {
          // Point right
          path.moveTo(drawX + 20, drawY); // Right point
          path.lineTo(drawX - 20, drawY - 20); // Top left
          path.lineTo(drawX - 20, drawY + 20); // Bottom left
        } else {
          // Point left
          path.moveTo(drawX - 20, drawY); // Left point
          path.lineTo(drawX + 20, drawY - 20); // Top right
          path.lineTo(drawX + 20, drawY + 20); // Bottom right
        }
        
        path.close();
        canvas.drawPath(path, playerPaint);
      } else {
        // Draw Circle
        canvas.drawCircle(Offset(drawX, drawY), 20, playerPaint);
      }
      
      // Draw Label
      final textSpan = TextSpan(
        text: label,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
