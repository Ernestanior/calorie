import 'package:health/health.dart';
import 'package:intl/intl.dart';

class HealthService {
  final Health _health = Health();

Future<bool> checkStepPermission() async {
  final now = DateTime.now();
  final lastWeek = now.subtract(const Duration(days: 7));

  try {
    var steps = await _health.getTotalStepsInInterval(lastWeek, now);
    // 如果拿到了数据，说明有权限
    return steps != null && steps != 0;
  } catch (e) {
    // 抛异常基本就是没权限
    return false;
  }
}

  /// 获取最近 N 天的步数
  Future<List<Map<String, dynamic>>> getSteps({int days = 30}) async {
    bool authorized = await _health.requestAuthorization([HealthDataType.STEPS]);

    if (!authorized) {
      throw Exception("未授权访问 HealthKit");
    }

    DateTime now = DateTime.now();
    List<Map<String, dynamic>> records = [];

    for (int i = 0; i < days; i++) {
      DateTime dayStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      DateTime dayEnd = dayStart.add(const Duration(days: 1));

      final steps = await _health.getTotalStepsInInterval(
        dayStart,
        dayEnd,
      );

      records.add({
        'date': DateFormat('MMM d').format(dayStart), // 和你 chart 里格式对齐
        'step': steps,
      });
    }

    // 倒序（从早到晚）
    records = records.reversed.toList();

    return records;
  }

  Future<int> getTodaySteps() async {
    bool authorized = await _health.requestAuthorization([HealthDataType.STEPS]);
    if (!authorized) {
      throw Exception("未授权访问 HealthKit");
    }
    DateTime now = DateTime.now();
    final steps = await _health.getTotalStepsInInterval(
        DateTime(now.year,now.month,now.day),
        now,
      );
    return steps ?? 0;
  }
}
