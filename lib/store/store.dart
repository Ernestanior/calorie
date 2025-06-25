import 'package:calorie/common/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  static Controller get c => Get.find();
  var tab = 'home'.obs;
  var tabIndex = 0.obs;
  var deviceId = ''.obs;
  var userAgent = ''.obs;
  var token = ''.obs;
  var user = RxMap<String, dynamic>(initUser);
  var image = RxMap<String, dynamic>({'mealType': 0, 'path': ""});
  var imgUrl = ''.obs;
  var lang = 'en_US'.obs;
  var style = ''.obs;
  var room = ''.obs;
  var foodDetail=RxMap<String, dynamic>({});
  var scanResult=RxMap<String, dynamic>({});

  Locale get currentLocale {
    final langCode = user['lang'];
    return getLocaleFromCode(langCode).value;
  }
}

Map<String, dynamic> initUser = {
    'id':0,
    'deviceId':'',
    'name':'',
    'phone':'',
    'age':0,
    'gender':0,
    'lang':'en',
    'unitType':0,
    'height':0,
    'currentWeight':0,
    'targetWeight':0,
    'activityFactor':0,
    'dailyCalories':0,
    'dailyCarbs':0,
    'dailyProtein':0,
    'dailyFats':0,
  };