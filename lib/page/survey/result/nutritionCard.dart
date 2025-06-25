import 'package:flutter/material.dart';
import 'dart:math';

class NutritionCard extends StatelessWidget {
  final String title;
  final dynamic total;
  final double percentage;
  final Color color;

  const NutritionCard({
    required this.title,
    required this.total,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color:Colors.white,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Stack(
          children: [
            Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    CustomPaint(
                      size: const Size(70, 70),
                      painter: CircularProgressPainter(percentage, color),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '$total',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
                
              ],
        ),
            ),
            // Positioned(
            //   bottom: 8,
            //   right: 8,
            //   child: Icon(Icons.edit, size: 16, color: Colors.black45),
            // ),
          ],
      ) 
     
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double percentage;
  final Color color;

  CircularProgressPainter(this.percentage, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    Paint foregroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    canvas.drawCircle(center, radius, backgroundPaint);

    double startAngle = -pi / 2;
    double sweepAngle = percentage * pi * 2;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
