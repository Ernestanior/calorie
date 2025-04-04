import 'package:get/get.dart';

class Controller extends GetxController {
  static Controller get c => Get.find();
  var tab = 'home'.obs;
  var tabIndex = 0.obs;
  var deviceId = ''.obs;
  var userAgent = ''.obs;
  var token = ''.obs;
  var user = RxMap<String, dynamic>({});
  var image = RxMap<String, String>({'base64': "", 'uri': ""});
  var imgUrl = ''.obs;
  var lang = 'en_US'.obs;
  var style = ''.obs;
  var room = ''.obs;
}
