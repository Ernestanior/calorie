import 'package:calorie/common/circlePainter/new.dart';
import 'package:flutter/material.dart';


/// 健康状况（身高、体重、BMI）
class HealthStatusCard extends StatelessWidget {
  const HealthStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:     Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 249, 246, 249),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("我的健康", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HealthInfoCard(title: "我的身高", value: "170", unit: "cm"),
                HealthInfoCard(title: "我的体重", value: "65.0", unit: "kg"),
                HealthInfoCard(title: "目标体重", value: "65.0", unit: "kg"),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.all(16),
              child: const BMICard(bmi:18),
            ),
          ],
        ),
      ),
    ),
      ); 
  }
}


/// 健康数值卡片
class HealthInfoCard extends StatelessWidget {
  final String title, value, unit;
  const HealthInfoCard({super.key, required this.title, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                children: [TextSpan(text: unit, style: const TextStyle(fontSize: 14, color: Colors.grey))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// 健康数值卡片
class EnergyInfoCard extends StatelessWidget {
  final String title, value, unit;
  const EnergyInfoCard({super.key, required this.title, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                children: [TextSpan(text: unit, style: const TextStyle(fontSize: 14, color: Colors.grey))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
