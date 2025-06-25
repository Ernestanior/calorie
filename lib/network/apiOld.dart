import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:calorie/store/store.dart';

String APP_VERSION = 'v1.2.15';
// String init_url = 'https://www.calorie.com/api/v1';
String init_url = 'http://43.160.200.196:9304/api';
String img_url = 'http://43.160.200.196';

class ApiConnect extends GetConnect {
  Future httpRequest(
    String path,
    String method, {
    Map<String, String>? headers,
    bool pass = false,
    Map<String, dynamic>? query,
    dynamic body,
  }) async {
    // final token = await LocalStorage().localStorage('get', 'ai-token');

    final initHeaders = {
      ...?headers,
      'app-user-locale': 'zh_CN',
      'version': APP_VERSION,
      'user-agent': Controller.c.userAgent.value,
      // 'token': token.toString(),
      // 'Finger-Print': Controller.c.deviceId.value
    };
    final res = await request(init_url + path, method,
        headers: initHeaders, body: body, query: query);
    if (res.body != null) {

      if (pass) {
        return res;
      } else {
        if (res.body is String || res.body['code']==404) {
          print('404');
          return res.body;
        } else {
          if (res.body['code'] == 200) {
            return res.body['data'];
          } 
          else {
            Fluttertoast.showToast(
                msg: '${res.body['path']} - ${res.body['error']}',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 2,
                backgroundColor: const Color(0xFF4D97D3),
                textColor: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 16.0);
            return res.body['msg'];
          }
        }
      }
    }
  }
}


Future login(String id) =>
    ApiConnect().httpRequest('/user/create', 'put',body:{'deviceId':id});

Future getUserDetail() => 
    ApiConnect().httpRequest('/user/detail', 'get',query: {'userId':'${Controller.c.user['id']}'});

//Calorie
Future imgRender(dynamic data) =>
    ApiConnect().httpRequest('/render/start', 'post', body: data);

Future aiAnalysis(Map data) =>
    ApiConnect().httpRequest('/deepseek/create', 'put', body: data,pass:true);

Future createRecord(int userId, String mealType,String sourceImg) =>
    ApiConnect().httpRequest('/detection/create', 'put', body: {'userId':userId,'mealType':mealType,'sourceImg':sourceImg});

Future dailyRecord(int userId, String date) =>
    ApiConnect().httpRequest('/detection/count-by-date', 'post', body: {'userId':userId,'startDateTime':'${date}T00:00:00','endDateTime':'${date}T23:59:59'});

Future fileUpload(FormData data) =>
    ApiConnect().httpRequest('/file/upload', 'put', body: data);

Future detectionCreate(dynamic data) =>
    ApiConnect().httpRequest('/detection/create', 'put', body: data);

Future detectionList(dynamic data) =>
    ApiConnect().httpRequest('/detection/page', 'post', body: data);


