import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerController extends GetxController {
  static TimerController get t => Get.find();

  RxInt remainingSeconds = 3599.obs; // 默认 2 小时
  RxBool offerStatus = false.obs;

  int? _endTimestamp;

  // 启动优惠计时
  Future<void> startRemaining() async {
    _endTimestamp = DateTime.now().millisecondsSinceEpoch + remainingSeconds.value * 1000;
    offerStatus.value = true;

    // 保存到本地，防止进程被杀
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("offer_end_time", _endTimestamp!);

    _tick();
  }

  void _tick() async {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));

      if (_endTimestamp != null) {
        int now = DateTime.now().millisecondsSinceEpoch;
        int diff = (_endTimestamp! - now) ~/ 1000;

        if (diff > 0) {
          remainingSeconds.value = diff;
          return true;
        }
      }

      reset();
      return false;
    });
  }

  Future<void> reset() async {
    offerStatus.value = false;
    remainingSeconds.value = 3599;
    _endTimestamp = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("offer_end_time");
  }

  // App 重启时恢复优惠状态
  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEnd = prefs.getInt("offer_end_time");

    if (storedEnd != null) {
      _endTimestamp = storedEnd;
      int now = DateTime.now().millisecondsSinceEpoch;
      int diff = (_endTimestamp! - now) ~/ 1000;

      if (diff > 0) {
        remainingSeconds.value = diff;
        offerStatus.value = true;
        _tick();
      } else {
        reset();
      }
    }
  }
}
