import 'package:flutter/material.dart';

class PlayerPainter extends CustomPainter {
  final String label;
  final Color color;
  final bool isFrontRow;
  final bool isLeftSide;

  PlayerPainter({
    required this.label,
    required this.color,
    required this.isFrontRow,
    required this.isLeftSide,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final playerPaint = Paint()..color = color;

    if (isFrontRow) {
      // Draw Triangle
      final path = Path();
      
      if (isLeftSide) {
        // Point right
        path.moveTo(center.dx + 20, center.dy); // Right point
        path.lineTo(center.dx - 20, center.dy - 20); // Top left
        path.lineTo(center.dx - 20, center.dy + 20); // Bottom left
      } else {
        // Point left
        path.moveTo(center.dx - 20, center.dy); // Left point
        path.lineTo(center.dx + 20, center.dy - 20); // Top right
        path.lineTo(center.dx + 20, center.dy + 20); // Bottom right
      }
      
      path.close();
      canvas.drawPath(path, playerPaint);
    } else {
      // Draw Circle
      canvas.drawCircle(center, 20, playerPaint);
    }

    // Draw Label
    final textSpan = TextSpan(
      text: label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
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
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
