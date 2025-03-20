import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightGoalChart extends StatefulWidget {
  @override
  _WeightGoalChartState createState() => _WeightGoalChartState();
}

class _WeightGoalChartState extends State<WeightGoalChart> {
  late List<ChartData> _chartData;

  @override
  void initState() {
    super.initState();
    _chartData = _generateChartData();
  }

  /// 生成数据，确保起点在顶部 (100kg)，终点在底部 (0kg)
  List<ChartData> _generateChartData() {
    return [
      ChartData('Today', 95, Colors.red),   // 起点 (显示)
      ChartData('Step1', 90, Colors.purple), // 中间点 (隐藏)
      ChartData('Step2', 60, Colors.blue),   // 中间点 (隐藏)
      ChartData('Step3', 20, Colors.indigo), // 中间点 (隐藏)
      ChartData('Goal', 5, Colors.blue),    // 终点 (显示)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [const Color.fromARGB(255, 241, 21, 6),Color.fromARGB(255, 255, 114, 104),Color.fromARGB(255, 2, 240, 205), const Color.fromARGB(255, 29, 153, 241)], // 从红色到蓝色
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: SfCartesianChart(
              primaryXAxis: NumericAxis(isVisible: false), // 隐藏 X 轴
              primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: 100), // 隐藏 Y 轴

              series: [
                /// SplineSeries 生成平滑曲线
                SplineSeries<ChartData, int>(
                  dataSource: _chartData,
                  xValueMapper: (ChartData data, _) => _chartData.indexOf(data),
                  yValueMapper: (ChartData data, _) => data.value,
                  color: Colors.white,
                  width: 6,
                  markerSettings: MarkerSettings(
                    isVisible: false, // 先显示所有点
                    shape: DataMarkerType.circle,
                    borderWidth: 3,
                    borderColor: const Color.fromARGB(0, 187, 31, 31),
                  ),
                  pointColorMapper: (ChartData data, index) {
                    return Colors.transparent;
                    // 只让起点和终点的标记可见
                    // return (index == 0 || index == _chartData.length - 1) ? const Color.fromARGB(0, 218, 48, 48) : Colors.transparent;
                  },
                  
                )
              ],

              // annotations: <CartesianChartAnnotation>[
              //   /// 起点（100kg）标签
              //   CartesianChartAnnotation(
              //     widget: _buildWeightLabel("100kg", Colors.red),
              //     coordinateUnit: CoordinateUnit.point,
              //     x: 0,
              //     y: 100,
              //   ),
              //   /// 终点（0kg）标签
              //   CartesianChartAnnotation(
              //     widget: _buildWeightLabel("0kg", Colors.blue),
              //     coordinateUnit: CoordinateUnit.point,
              //     x: _chartData.length - 1,
              //     y: 0,
              //   ),
              // ],
            ));
  }

  /// 构建数值标签
  Widget _buildWeightLabel(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// 数据类
class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData(this.label, this.value, this.color);
}
