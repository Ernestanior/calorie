import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class WeightCard extends StatelessWidget {
  final double currentWeight;
  final double minWeight;
  final double maxWeight;
  final VoidCallback onAdd;
  final VoidCallback onMore;

  const WeightCard({
    super.key,
    required this.currentWeight,
    required this.minWeight,
    required this.maxWeight,
    required this.onAdd,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final percent =
        ((currentWeight - minWeight) / (maxWeight - minWeight)).clamp(0.0, 1.0);

    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(31, 146, 154, 218),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // 标题行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weight',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: onAdd,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE6ECF5),
                  ),
                  child: const Icon(Icons.add, size: 16, color: Colors.black),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 80,
            width: 150,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                // 半圆进度条
                CustomPaint(
                  size: const Size(120, 40),
                  painter: SemiArcPainter(percent),
                ),
                Positioned(
                  top: 45,
                  child: Container(
                      width: 130,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(minWeight.toStringAsFixed(1),
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey)),
                          Text(maxWeight.toStringAsFixed(1),
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey)),
                        ],
                      )),
                ),
                // 当前体重
                Positioned(
                  top: 55,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: currentWeight.toStringAsFixed(1),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        TextSpan(
                          text: Controller.c.user['unitType']==0?' kg':' lbs',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          // more 按钮
          // GestureDetector(
          //   onTap: onMore,
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //     decoration: BoxDecoration(
          //       color: const Color(0xFFF2F5FF),
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: const Text('More >', style: TextStyle(color: Colors.blue, fontSize: 12)),
          //   ),
          // )
        ],
      ),
    );
  }
}

class SemiArcPainter extends CustomPainter {
  final double percent;

  SemiArcPainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = const Color(0xFFE6ECF5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = const Color(0xFFB6C6F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = pi * 1.15;
    final sweepAngle = pi * 0.7;

    // 背景半圆
    canvas.drawArc(rect, startAngle, sweepAngle, false, backgroundPaint);
    // 进度半圆
    canvas.drawArc(
        rect, startAngle, sweepAngle * percent, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
