import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StepChart extends StatefulWidget {
  final List<dynamic> recordList;

  const StepChart({super.key, required this.recordList});
  @override
  _StepChartState createState() => _StepChartState();
}

class _StepChartState extends State<StepChart> {
  int selectedRangeIndex = 0;

  final List<String> ranges = ['LAST_WEEK'.tr, 'LAST_MONTH'.tr, 'LAST_3_MONTHS'.tr];



  DateTime parseDate(String str) {
    final year = DateTime.now().year;
    return DateFormat('MMM d').parse(str).copyWith(year: year);
  }

  List get filteredRecords {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (selectedRangeIndex) {
      case 0:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 1:
        startDate = now.subtract(const Duration(days: 30));
        break;
      case 2:
        startDate = now.subtract(const Duration(days: 90));
        break;
      default:
        startDate = now.subtract(const Duration(days: 7));
    }

    return widget.recordList
        .where((record) {
          DateTime date = parseDate(record['date']);
          return date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              date.isBefore(now.add(const Duration(days: 4)));
        })
        .toList()
      ..sort((a, b) => parseDate(a['date']).compareTo(parseDate(b['date'])));
  }

  @override
  Widget build(BuildContext context) {
  int targetStep = Controller.c.user['targetStep'] ?? 8000;

    if (widget.recordList.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Text(
          'NO_RECORDS'.tr,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    final List data = filteredRecords;
    final spots = <FlSpot>[];
    final labels = <int, String>{};

    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), (data[i]['step'] as num).toDouble()));
      labels[i] = data[i]['date'];
    }
    num minY = [...spots.map((e) => e.y), targetStep].reduce((a, b) => a < b ? a : b);
    num maxY = [...spots.map((e) => e.y), targetStep].reduce((a, b) => a > b ? a : b);
    num yRange = (maxY - minY) ==0?1:(maxY - minY) ;
    minY = ((minY - yRange * 0.1)/1000).floorToDouble()*1000 ;
    maxY = ((maxY + yRange * 0.1)/1000).ceilToDouble()*1000 ;
    double intervalY = ((maxY - minY) / 6/1000).ceilToDouble()*1000;

    List<int> xLabelIndexes = [];
    int len = labels.length;
    if (len > 0) {
      if (selectedRangeIndex == 0) {
        xLabelIndexes = [0, len ~/ 2, len - 1];
      } else {
        xLabelIndexes = [0, len ~/ 4, len ~/ 2, (len * 3 ~/ 4), len - 1];
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('STEPS_STATISTICS'.tr,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 35), 
          // Range Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ranges.map((range) {
              final isSelected = selectedRangeIndex == ranges.indexOf(range);
              return GestureDetector(
                onTap: () => setState(() => selectedRangeIndex = ranges.indexOf(range) ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color.fromARGB(255, 255, 243, 239) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    range,
                    style: TextStyle(
                      color: isSelected ? const Color.fromARGB(255, 228, 128, 34) : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 50),
          // Chart
          SizedBox(
            height: 300,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: (spots.length * 50).toDouble().clamp(300, 1000),
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX:
                        spots.isNotEmpty ? (spots.length - 1).toDouble() : 1,
                    minY: 0,
                    maxY: maxY+3000,
                    gridData: const FlGridData(show: false), // 不显示辅助线
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: targetStep.toDouble(),
                          color: const Color.fromARGB(255, 255, 195, 14),
                          strokeWidth: 2,
                          dashArray: [3],
                          label: HorizontalLineLabel(
                            show: true,
                            alignment: Alignment.topRight,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 156, 8),
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                            labelResolver: (_) => 'TARGET_STEPS'.tr,
                          ),
                        ),
                      ],
                    ),
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.black87,
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((barSpot) {
                            final index = barSpot.x.toInt();
                            final step =
                                barSpot.y.toStringAsFixed(1);
                            final date = labels[index] ?? '';
                            return LineTooltipItem(
                              '$date\n$step ',
                              const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            );
                          }).toList();
                        },
                      ),
                      getTouchedSpotIndicator:
                          (barData, spotIndexes) {
                        return spotIndexes.map((index) {
                          return TouchedSpotIndicatorData(
                            const FlLine(color: Color.fromARGB(214, 243, 110, 33), strokeWidth: 1,dashArray:[3]),
                            FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) =>
                                  FlDotCirclePainter(
                                radius: 3,
                                color: const Color.fromARGB(255, 255, 191, 72),
                                strokeWidth: 1,
                                strokeColor: Colors.white,
                              ),
                            ),
                          );
                        }).toList();
                      },
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, _) {
                            if (xLabelIndexes.contains(value.toInt())) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 6), // ✅ 向下偏移
                                child: Text(
                                  labels[value.toInt()] ?? '',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          reservedSize:35,
                          showTitles: true,
                          interval: intervalY,
                          getTitlesWidget: (value, _) => Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(fontSize: 10), // Y轴字体变小
                          ),
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        barWidth: 2,
                        color: const Color.fromARGB(255, 255, 196, 18),
                        dotData: FlDotData(show: true,getDotPainter: (FlSpot spot, double xPercentage, LineChartBarData bar, int index) {
                            return FlDotCirclePainter(
                              radius: 3,
                              color:  const Color.fromARGB(255, 255, 151, 14),
                              strokeColor:  const Color.fromARGB(255, 255, 255, 255),
                            );
                          },),
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color.fromARGB(255, 255, 202, 159).withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
