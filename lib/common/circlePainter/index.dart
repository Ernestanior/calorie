import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BmiGaugeWidget extends StatelessWidget {
  final double bmi;

  const BmiGaugeWidget({super.key, required this.bmi});

  @override
  Widget build(BuildContext context) {
    return   Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "YOUR_BMI".tr,
                  style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                  
                ),
                const SizedBox(width: 8),
                Container(
                  padding:const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getBmiCategoryColor(bmi),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _getBmiCategory(bmi),
                    style:const TextStyle(fontSize: 11, color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              bmi.toStringAsFixed(1),
              style:const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                const BmiGauge(),
                _buildPointer(context, bmi),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLegend("UNDERWEIGHT".tr, Colors.blue),
                _buildLegend("HEALTHY".tr, Colors.green),
                _buildLegend("OVERWEIGHT".tr, Colors.orange),
                _buildLegend("FAT2".tr, Colors.red),
              ],
            ),
          ],
        );
  }

  /// BMI 指针
  Widget _buildPointer(BuildContext context, double bmi) {
    double position = (bmi - 15) / (35 - 15); // 映射 BMI 到进度条范围 (15 - 35)
    position = position.clamp(0.0, 0.79); // 限制范围

    return Positioned(
      left: position * MediaQuery.of(context).size.width ,
      child: Container(
        width: 3,
        height: 30,
        color: Colors.black,
      ),
    );
  }

  /// 分类文本颜色
  Color _getBmiCategoryColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 24) return Colors.green;
    if (bmi < 28) return Colors.orange;
    return Colors.red;
  }

  /// 获取 BMI 类别
  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return "UNDERWEIGHT".tr;
    if (bmi < 24) return "HEALTHY".tr;
    if (bmi < 28) return "OVERWEIGHT".tr;
    return "FAT2".tr;
  }

  /// 构建分类标注
  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 4),
        Text(label, style:const TextStyle(fontSize: 11,fontWeight: FontWeight.bold)),
      ],
    );
  }
}

/// **自定义 BMI 进度条**
class BmiGauge extends StatelessWidget {
  const BmiGauge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.green, Colors.yellow, Colors.red],
          stops: [0.1, 0.4, 0.65, 1.0],
        ),
      ),
    );
  }
}
