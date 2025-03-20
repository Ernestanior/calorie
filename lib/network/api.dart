
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:calorie/store/store.dart';
import 'package:calorie/store/token.dart';

String APP_VERSION = 'v1.2.15';
// String init_url = 'https://www.calorie.com/api/v1';
String init_url = 'http://10.10.20.24:9304/api';

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
    // if (token != null && token != "2FA验证失败, 请检查后再次尝试") {
    //   initHeaders['token'] = token;
    // }
    // print(init_url + path);

    var res = await request(init_url + path, method,
        headers: initHeaders, body: body, query: query);
    // print(res.request);
    // print(res.body);
    if (res.body != null) {
      if (pass) {
        return res;
      } else {
        if (res.body is String) {
          print('404');
          return res.body;
        } else {
          if (res.body['code'] == 200) {
            return res.body['data'];
          } 
          else {
            Fluttertoast.showToast(
                msg: res.body['msg'],
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

Future getBaseUrl() => ApiConnect().httpRequest('/info/app', 'get');

//Calorie
Future imgRender(dynamic data) =>
    ApiConnect().httpRequest('/render/start', 'post', body: data);





Future register(Map data) =>
    ApiConnect().httpRequest('/user/register', 'post', body: data);
Future googleLogin(String token) => ApiConnect()
    .httpRequest('/user/google-login', 'get', query: {'token': token});
Future appleLogin(dynamic data) =>
    ApiConnect().httpRequest('/user/apple-login', 'post', body: data);
Future getUserDetail() => ApiConnect().httpRequest('/user/detail', 'get');
Future updateUser(Map data) =>
    ApiConnect().httpRequest('/user/update', 'put', body: data);
Future updatePwd({required String password, required String newPassword}) =>
    ApiConnect().httpRequest('/user/update-password', 'put',
        body: {'password': password, 'newPassword': newPassword});
Future deleteUser(String remarks) =>
    ApiConnect().httpRequest('/user/delete', 'put', body: {'remarks': remarks});
Future imgHistory(Map data) =>
    ApiConnect().httpRequest('/img/history', 'post', body: data);
Future freeToken() => ApiConnect().httpRequest('/user/img/free-token', 'get');
Future base64Upload(FormData data) =>
    ApiConnect().httpRequest('/img/app/upload', 'post', body: data);
Future imgProgress(String taskId) =>
    ApiConnect().httpRequest('/img/progress', 'get', query: {'taskId': taskId});
Future imgResult(String taskId) =>
    ApiConnect().httpRequest('/img/result', 'get', query: {'taskId': taskId});
Future imgDelete(int id) => ApiConnect()
    .httpRequest('/img/delete', 'delete', query: {'id': id.toString()});
Future imgDeleteVisitor(int id) => ApiConnect()
    .httpRequest('/img/delete/render-visitor', 'delete', query: {'id': id});
Future renderCancel(String id) =>
    ApiConnect().httpRequest('/img/render', 'put', query: {'taskId': id});
Future googleAuthCodeDisable() => ApiConnect().httpRequest(
      '/user/google-auth-code-disable',
      'get',
    );
Future googleAuthCode() => ApiConnect().httpRequest(
      '/user/google-auth-code',
      'get',
    );

Future verifyAuthCode(String code, {String? token}) =>
    ApiConnect().httpRequest('/user/verify-auth-code', 'get',
        query: {'code': code}, headers: token == null ? {} : {'token': token});
