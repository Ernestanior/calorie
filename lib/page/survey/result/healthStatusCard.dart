import 'package:calorie/common/circlePainter/new.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


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
            Text("MY_HEALTH".tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HealthInfoCard(title: "HEIGHT".tr, value: Controller.c.user['height'], unit: Controller.c.user['unitType']==0?"cm":"inch"),
                HealthInfoCard(title: "WEIGHT".tr, value: Controller.c.user['currentWeight'], unit: Controller.c.user['unitType']==0?"kg":"lbs"),
                HealthInfoCard(title: "TARGET_WEIGHT".tr, value: Controller.c.user['targetWeight'], unit: Controller.c.user['unitType']==0?"kg":"lbs"),
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
              child: BMICard(bmi:Controller.c.user['unitType']==0?double.parse((Controller.c.user['currentWeight']/(Controller.c.user['height']*Controller.c.user['height']/10000)).toStringAsFixed(2)):double.parse((Controller.c.user['currentWeight']/(Controller.c.user['height']*Controller.c.user['height'])*703).toStringAsFixed(2))),
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
  final String title, unit;
  final dynamic value;
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
            Text(title, style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 116, 116, 116))),
            const SizedBox(height: 6),
            Text.rich(
              TextSpan(
                text: '$value',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                children: [TextSpan(text: ' $unit', style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 113, 113, 113), fontWeight: FontWeight.normal))],
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
