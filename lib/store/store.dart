import 'dart:io';

import 'package:calorie/common/util/utils.dart';
import 'package:calorie/network/api.dart';
import 'package:dio/dio.dart' as dio;
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
  var lang = 'en_US'.obs;
  var style = ''.obs;
  var room = ''.obs;
  RxBool refreshHomeDataTrigger = false.obs;
  var foodDetail=RxMap<String, dynamic>({});
  RxBool scanState = true.obs;
  var scanResult=RxMap<String, dynamic>({});

  Locale get currentLocale {
    final langCode = user['lang'];
    return getLocaleFromCode(langCode).value;
  }

  // 👇 新增分析任务状态
  var isAnalyzing = false.obs;
  var analyzingProgress = 0.0.obs; // 范围 0~1
  var analyzingFilePath = ''.obs;

Future<void> startAnalyzing() async {
  if (image['path'] is! String) return;

  isAnalyzing.value = true;
  analyzingFilePath.value = image['path'];
  analyzingProgress.value = 0.0;

  /// 👇 用于控制模拟进度是否继续
  bool isRealRequestFinished = false;

  /// 👇 模拟进度（可中断）
  Future<void> simulateProgress() async {
    for (int i = 1; i <= 4; i++) {
      if (isRealRequestFinished) return; // 如果真实请求已完成，就终止模拟
      await Future.delayed(const Duration(milliseconds: 5000));
      analyzingProgress.value = i * 0.2;
    }
  }

  // 启动模拟进度
  simulateProgress();

  // 执行真实上传与分析请求
  try {
    File imageFile = File(image['path']);
    dio.FormData formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(imageFile.path, filename: "upload.jpg"),
    });

    final url = await fileUpload(formData);
    if (url == null) {
      isAnalyzing.value = false;
      return;
    }

    final res = await detectionCreate({
      'userId': Controller.c.user['id'],
      'mealType': Controller.c.image['mealType'],
      'sourceImg': imgUrl + url
    });

    isRealRequestFinished = true; // ✅ 真实请求已完成，终止模拟进度
    analyzingProgress.value = 1;

    isAnalyzing.value = false;

    // 触发首页刷新
    Controller.c.refreshHomeDataTrigger.value = true;

  } catch (e) {
    isRealRequestFinished = true;
    isAnalyzing.value = false;
    print("分析失败: $e");
  }
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