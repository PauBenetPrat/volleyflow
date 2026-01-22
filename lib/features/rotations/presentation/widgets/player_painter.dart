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
    
    // Create Path for Shadow and Shape
    final path = Path();
    if (isFrontRow) {
      if (isLeftSide) {
        path.moveTo(center.dx + 28, center.dy);
        path.lineTo(center.dx - 28, center.dy - 28);
        path.lineTo(center.dx - 28, center.dy + 28);
      } else {
        path.moveTo(center.dx - 28, center.dy);
        path.lineTo(center.dx + 28, center.dy - 28);
        path.lineTo(center.dx + 28, center.dy + 28);
      }
      path.close();
    } else {
      path.addOval(Rect.fromCircle(center: center, radius: 28));
    }

    // Draw subtle shadow for modern elevation effect
    canvas.drawShadow(path, Colors.black, 2.5, true);

    // Draw solid fill (modern flat design)
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(path, paint);
    
    // Draw subtle border for definition
    final borderPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
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
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
