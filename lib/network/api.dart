import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide FormData;
import 'package:intl/intl.dart';

import '../store/store.dart';

 const String baseUrl = 'https://www.xyvnai.com/api';
 const String imgUrl = 'https://www.xyvnai.com';

//  const String baseUrl = 'http://10.10.20.34:9304/api';
//  const String imgUrl = 'http://10.10.20.34';

class DioService {
  static final DioService _instance = DioService._internal();
  factory DioService() => _instance;

  late Dio _dio;
  DioService._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60000),
      receiveTimeout: const Duration(seconds: 60000),
      headers: {
        'app-user-locale': 'zh_CN',
        'version': 'v1.2.15',
      },
    );

    _dio = Dio(options);

    // 添加日志或拦截器
    // _dio.interceptors.add(LogInterceptor(
      // request: true,
      // responseBody: true,
      // requestHeader: true,
      // responseHeader: false,
      // error: true,
    // ));
  }

  Future<dynamic> request(
    String path,
    String method, {
    Map<String, dynamic>? query,
    dynamic body,
    Map<String, String>? headers,
    bool pass = false,
  }) async {
    try {
      final options = Options(
        method: method,
        headers: headers,
        contentType: body is FormData
            ? 'multipart/form-data'
            : 'application/json',
      );

      final response = await _dio.request(
        path,
        data: body,
        queryParameters: query,
        options: options,
      );

      final data = response.data;

      if (pass) return response;

      if (data is String || data['code'] == 404) {
        return data;
      } else if (data['code'] == 200) {
        return data['data'];
      } else {
        print('request error $data');
        return data['msg'];
      }
    } catch (e) {
      print('请求失败: $e');
        // Get.defaultDialog(title:'OOPS'.tr,
        // titleStyle: TextStyle(fontSize: 18),
        // content:Text('NETWORK_ERROR'.tr),
        // contentPadding: EdgeInsets.all(10));

      Fluttertoast.showToast(
        msg: 'NETWORK_ERROR'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return "-1";
    }
  }
}

Future login(String id,dynamic data) =>
    DioService().request('/user/create', 'put',body:{'deviceId':id,...data});

Future userModify(dynamic data) =>
    DioService().request('/user/modify', 'put',body:{'id':'${Controller.c.user['id']}',...data});

Future getUserDetail() => 
    DioService().request('/user/detail', 'get',query: {'id':'${Controller.c.user['id']}'});

Future userDelete() => 
    DioService().request('/user/delete', 'delete',query: {'id':'${Controller.c.user['id']}'});

Future getUserDietaryAdvice() => 
    DioService().request('/user/list/dietary/advice', 'get',query: {'id':'${Controller.c.user['id']}'});

Future imgRender(dynamic data) =>
    DioService().request('/render/start', 'post', body: data);

Future deepseekReason(Map data) =>
    DioService().request('/deepseek/create-reasoner', 'put', body: data,pass:true);

Future deepseekResult(Map data) =>
    DioService().request('/deepseek/create-chat', 'put', body: data,pass:true);

Future openAiReason(Map data) =>
    DioService().request('/openAI/create-reasoner', 'put', body: data,pass:true);

Future openAiResult(Map data) =>
    DioService().request('/openAI/create-chat', 'put', body: data,pass:true);

Future dailyRecord(int userId, String date) =>
    DioService().request('/detection/count-by-date', 'post', body: {'userId':userId,'startDateTime':'${date}T00:00:00','endDateTime':'${date}T23:59:59'});

Future fileUpload(FormData data) =>
    DioService().request('/file/upload', 'put', body: data);


Future detectionCreate(dynamic data) =>
    DioService().request('/detection/create', 'put', body: data);

Future detectionList(int page,int pageSize,{String? date}){
  if(date==null){
    return DioService().request('/detection/page', 'post', 
    body: {
      'userId':Controller.c.user['id'],
      'searchPage':{'page':page,'pageSize':pageSize,'desc':1,'sort':'createDate'},
    });
  }else{
    return DioService().request('/detection/page', 'post', 
    body: {
      'userId':Controller.c.user['id'],
      'searchPage':{'page':page,'pageSize':pageSize,'desc':1,'sort':'createDate'},
      'startDateTime':'${date}T00:00:00','endDateTime':'${date}T23:59:59'
    });
  }
}

Future detectionModify(int id,dynamic data) =>
    DioService().request('/detection/modify', 'put',body: {'userId':'${Controller.c.user['id']}','id':id,...data});

Future detectionModify1(int id,String dishName, int mealType) =>
    DioService().request('/detection/modify', 'put',body: {'userId':'${Controller.c.user['id']}','id':id,'dishName':dishName,'mealType':mealType});


Future detectionDelete() =>
    DioService().request('/detection/delete', 'delete',query: {'userId':'${Controller.c.user['id']}'});


// 每日拍照记录
Future recordPage(int page,int pageSize) =>
    DioService().request('/foodNutrition/page', 'post', body: {'id':Controller.c.user['id'],'searchPage':{'page':page,'pageSize':pageSize,'desc':0,'sort':'createDate'}});

Future recordDelete(dynamic data) =>
    DioService().request('/foodNutrition/delete', 'delete', body: data);

Future recordModify(dynamic data) =>
    DioService().request('/foodNutrition/modify', 'put', body: data);

Future recordCreate(dynamic data) =>
    DioService().request('/foodNutrition/create', 'put', body: data);


    // 体重记录
Future weightPage(String date) =>
    DioService().request('/weightRecord/page', 'post', body: {'date':date,'userId':Controller.c.user['id'],'searchPage':{'page':1,'pageSize':999,'desc':0,'sort':'id'}});
   
Future weightDelete(int id) =>
    DioService().request('/weightRecord/delete', 'delete', body: {'id':id});

Future weightModify(dynamic data) =>
    DioService().request('/weightRecord/modify', 'put', body: data);

Future weightCreate(double weight) =>
    DioService().request('/weightRecord/create', 'put', body: {'userId':Controller.c.user['id'],'date':DateFormat('yyyy-MM-dd').format(DateTime.now()),'weight':weight});



    // 计划集合
Future recipeSetPage() =>
    DioService().request('/recipeSet/page', 'post', body: {'visible':1,'searchPage':{'page':1,'pageSize':999,'desc':0,'sort':'id'}});
// 用户收藏食谱的集合
  Future recipeSetCollects() =>
    DioService().request('/user/page/recipeSet', 'post', body: {'id':Controller.c.user['id'],'searchPage':{'page':1,'pageSize':999,'desc':0,'sort':'id'}});
  // 每一天的三餐菜谱
Future recipePage(int id,int day) =>
    DioService().request('/recipe/page', 'post', body: {'recipeSetId':id,'day':day,'searchPage':{'page':1,'pageSize':999,'desc':0,'sort':'id'}});
