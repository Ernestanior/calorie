import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class NutritionPieChart extends StatelessWidget {
  final double calories;
  final double carb;    // 克
  final double protein; // 克
  final double fat;     // 克

  const NutritionPieChart({
    Key? key,
    required this.calories,
    required this.carb,
    required this.protein,
    required this.fat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double total = carb + protein + fat;
    double carbPercent = total == 0 ? 0 : (carb / total * 100);
    double proteinPercent = total == 0 ? 0 : (protein / total * 100);
    double fatPercent = total == 0 ? 0 : (fat / total * 100);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding:EdgeInsets.symmetric(vertical: 30,horizontal: 15),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: const Color.fromARGB(31, 147, 147, 147), blurRadius: 10)],
      ),
      child:Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 饼图
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: PieChart(
                PieChartData(
                  startDegreeOffset: -90,
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: _buildSections(carbPercent, proteinPercent, fatPercent),
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  '摄入热量',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                ),
                Text(
                  '${calories.toInt()}',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'kcal',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(width: 40),
        // 右侧文字
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('营养占比',style:TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _buildNutrientRow('碳水', carbPercent, carb, const Color.fromARGB(255, 255, 216, 100)),
            SizedBox(height: 12),
            _buildNutrientRow('蛋白质', proteinPercent, protein, Colors.pinkAccent),
            SizedBox(height: 12),
            _buildNutrientRow('脂肪', fatPercent, fat, Colors.lightBlueAccent),
          ],
        )
      ],
    ));
  }

  List<PieChartSectionData> _buildSections(double carbPercent, double proteinPercent, double fatPercent) {
    return [
      PieChartSectionData(
        color: const Color.fromARGB(167, 255, 100, 131),
        value: carbPercent,
        radius: 18,
        title: '',
      ),
      PieChartSectionData(
        color: const Color.fromARGB(121, 255, 204, 0),
        value: proteinPercent,
        radius: 18,
        title: '',
      ),
      PieChartSectionData(
        color: const Color.fromARGB(133, 64, 195, 255),
        value: fatPercent,
        radius: 18,
        title: '',
      ),
    ];
  }

  Widget _buildNutrientRow(String name, double percent, double gram, Color color) {
    return  Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6),
        Text(
          '$name ${percent.toStringAsFixed(1)}%',
          style: TextStyle(fontSize: 12, color: Colors.black87),
        ),
                SizedBox(width: 16),

        Text(
          '${gram.toStringAsFixed(1)}g',
          style: TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
   }
}
