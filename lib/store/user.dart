import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:calorie/network/api.dart';

class UserInfo {
  getUserInfo() async {
      final res = await getUserDetail();
      print('UserInfo $res');
      if(res == "-1"){
        return;
      }
      Locale locale;
      if (res['lang'] == 'en_US') {
        locale = const Locale('en', 'US');
        Get.updateLocale(locale);
      } else {
        locale = const Locale('zh', 'CN');
        Get.updateLocale(locale);
      }

      Controller.c.user(res);
      Controller.c.lang(res['lang']);
  }
}
