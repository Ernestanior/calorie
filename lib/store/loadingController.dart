import 'package:get/get.dart';

class LoadingController extends GetxController {
  var loadingCount = 0.obs;

  bool get isLoading => loadingCount > 0;

  void showLoading() => loadingCount++;
  void hideLoading() {
    if (loadingCount > 0) loadingCount--;
  }
}
