import 'package:calorie/common/camera/index.dart';
import 'package:calorie/common/icon/index.dart';
import 'package:calorie/common/locale/index.dart';
import 'package:calorie/common/tabbar/floatBtn.dart';
import 'package:calorie/common/tabbar/bottomBar.dart';
import 'package:calorie/network/api.dart';
import 'package:calorie/page/aboutUs/index.dart';
import 'package:calorie/page/aboutUs/service.dart';
import 'package:calorie/page/contactUs/index.dart';
import 'package:calorie/page/home/index.dart';
import 'package:calorie/page/login/index.dart';
import 'package:calorie/page/profile/index.dart';
import 'package:calorie/page/profileDetail/index.dart';
import 'package:calorie/page/scan/index.dart';
import 'package:calorie/page/survey/index.dart';
import 'package:calorie/page/weight/index.dart';
import 'package:calorie/store/store.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'page/aboutUs/privacy.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.lazyPut<ApiConnect>(() => ApiConnect());
  Get.lazyPut(() => Controller());

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
  var res = await login(iosInfo.identifierForVendor as String);
  Controller.c.user(res);
  runApp(const CalAiApp());
}

class CalAiApp extends StatefulWidget {
  const CalAiApp({super.key});

  @override
  State<CalAiApp> createState() => _CalAiAppState();
}

class _CalAiAppState extends State<CalAiApp> with SingleTickerProviderStateMixin{

    @override
    Widget build(BuildContext contextX) {
    return GetMaterialApp(
      translations: Messages(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('zh', 'CN'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor:  Colors.white),
        useMaterial3: true,
      ),
      initialRoute: '/', //2、调用onGenerateRoute处理
      getPages: [
        GetPage(name: "/", page: () => BottomNavScreen()), // 首页（带底部导航）
        GetPage(name: "/profileDetail", page: () => ProfileDetail()), // 详情页（无底部导航）
        GetPage(name: "/weight", page: () => Weight()), 
        GetPage(name: "/contactUs", page: () => ContactUs()), 
        GetPage(name: "/aboutUs", page: () => AboutUs()), 
        GetPage(name: "/privacy", page: () => Privacy()), 
        GetPage(name: "/service", page: () => Service()), 
        GetPage(name: "/camera", page: () => CameraScreen()), 
        GetPage(name: "/scan", page: () => ScanAnimationPage()), 

      ],
    );
  }
}


class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const Profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    if (Controller.c.user['height']==null) {
      return Scaffold(
      backgroundColor: Colors.white,
      body:MultiStepForm());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex], // 切换不同页面
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: Colors.grey,
        items:[
          BottomNavigationBarItem(icon: Icon(AliIcon.home, size: 30), label: "HOME".tr),
          BottomNavigationBarItem(icon: Icon(AliIcon.mine, size: 30), label: "MINE".tr),
        ],
      ),
      floatingActionButton:  const FloatBtn(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

