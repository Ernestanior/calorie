
import 'package:calorie/common/camera/index.dart';
import 'package:calorie/common/locale/index.dart';
import 'package:calorie/common/tabbar/floatBtn.dart';
import 'package:calorie/common/tabbar/index.dart';
import 'package:calorie/common/util/deviceId.dart';
import 'package:calorie/common/util/utils.dart';
import 'package:calorie/network/api.dart';
import 'package:calorie/page/aboutUs/index.dart';
import 'package:calorie/page/aboutUs/service.dart';
import 'package:calorie/page/contactUs/index.dart';
import 'package:calorie/page/premium/index.dart';
import 'package:calorie/page/recipe/detail/index.dart';
import 'package:calorie/page/recipe/index.dart';
import 'package:calorie/page/foodDetail/index.dart';
import 'package:calorie/page/home/index.dart';
import 'package:calorie/page/profile/index.dart';
import 'package:calorie/page/profileDetail/index.dart';
import 'package:calorie/page/recipe/myPlan.dart';
import 'package:calorie/page/records/index.dart';
import 'package:calorie/page/step/index.dart';
import 'package:calorie/page/survey/index.dart';
import 'package:calorie/page/scan/index.dart';
import 'package:calorie/page/scan/result/index.dart';
import 'package:calorie/page/setting/index.dart';
import 'package:calorie/page/survey/analysis.dart';
import 'package:calorie/page/survey/result/index.dart';
import 'package:calorie/page/weight/index.dart';
import 'package:calorie/page/guide/index.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'page/aboutUs/privacy.dart';



final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

dynamic initData = {
  'age': 18,
  'height': 175,
  'gender': 1,
  'initWeight': 65,
  'currentWeight': 65,
  'targetWeight': 65,
  'targetStep': 8000,
  'dailyCalories': 2200,
  'dailyCarbs': 300,
  'dailyFats': 70,
  'dailyProtein': 70,
  "unitType": 0,
  'targetType': 1,
  "lang": "en_US"
};
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Get.lazyPut<ApiConnect>(() => ApiConnect());
  Get.lazyPut(() => Controller());
  Get.lazyPut(() => RecipeController());


  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  final deviceId = await DeviceIdManager.getId();
  var langCode = 'en_US';
  try {
    var res = await login(deviceId, initData);
    // 保存用户信息到全局
    if (res != "-1") {
      Controller.c.user(res);
      RecipeController.r.fetchRecipes();
      // 设置初始语言
      Controller.c.lang(res['lang']);
      langCode = res?['lang'] ?? 'en_US';
    }
  } catch (e) {
    print('error $e');
  } finally {

    final locale = getLocaleFromCode(langCode).value;
    Get.updateLocale(locale);
  }

  // 初始化 SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  bool firstOpen = prefs.getBool('first_open') ?? true; // 默认第一次打开为 true
  // 如果是第一次打开，显示 GuidePage；否则显示 BottomNavScreen
  Widget initialPage = firstOpen ? const GuidePage() : const BottomNavScreen();

  // 可在第一次打开后保存状态
  if (firstOpen) {
    await prefs.setBool('first_open', false);
  }


  runApp(CalAiApp(initialPage: initialPage));
}

class CalAiApp extends StatefulWidget {
  final Widget initialPage;
  const CalAiApp({super.key, required this.initialPage});

  @override
  State<CalAiApp> createState() => _CalAiAppState();
}

class _CalAiAppState extends State<CalAiApp>
    with SingleTickerProviderStateMixin {
      
// @override
//   void initState() {
//     super.initState();
//     _initFluwx();
//   }
// Future<void> _initFluwx() async {
//     Fluwx fluwx = Fluwx();
//     bool result = await fluwx.registerApi(
//       appId: "wxc1dbd72b3f8b10cc",  // 替换为你的微信 App ID
//       universalLink: "https://xyvnai.com/vitaai/",  // iOS 专用，替换为你的 Universal Link
//     );
//     if (result) {
//       print("Fluwx 注册成功");
//     } else {
//       print("Fluwx 注册失败");
//     }
//   }
  @override
  Widget build(BuildContext contextX) {
    return GetMaterialApp(
      translations: Messages(),
      navigatorObservers: [routeObserver],
      locale: Get.locale,
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: '/', //2、调用onGenerateRoute处理
      home: widget.initialPage,
      getPages: [
        // GetPage(name: "/", page: () => BottomNavScreen()), 
        GetPage(name: "/home", page: () => BottomNavScreen()), 
        GetPage(name: "/profile", page: () => Profile()), 
        GetPage(
            name: "/profileDetail", page: () => ProfileDetail()), // 详情页（无底部导航）
        GetPage(name: "/weight", page: () => Weight()),
        GetPage(name: "/premium", page: () => Premium()),
        GetPage(name: "/step", page: () => StepPage()),
        GetPage(name: "/guide", page: () => GuidePage()),
        GetPage(name: "/contactUs", page: () => ContactUs()),
        GetPage(name: "/aboutUs", page: () => AboutUs()),
        GetPage(name: "/privacy", page: () => Privacy()),
        GetPage(name: "/service", page: () => Service()),
        GetPage(name: "/camera", page: () => CameraScreen()),
        GetPage(name: "/records", page: () => Records()),
        GetPage(name: "/scan", page: () => ScanAnimationPage()),
        GetPage(name: "/scanResult", page: () => ScanResult()),
        GetPage(name: "/survey", page: () => MultiStepForm()),
        GetPage(name: "/surveyAnalysis", page: () => SurveyAnalysis()),
        GetPage(name: "/surveyResult", page: () => SurveyResult()),
        GetPage(name: "/recipe", page: () => RecipePage()),
        GetPage(name: "/recipeCollect", page: () => RecipeCollect()),
        GetPage(name: "/recipeDetail", page: () => RecipeDetail()),
        GetPage(name: "/foodDetail", page: () => FoodDetail()), 
        GetPage(name: "/setting", page: () => Setting()), 
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
  // int _selectedIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {"icon": Icons.check_box, "label": "记录"},
    // {"icon": Icons.restaurant_menu, "label": "食谱"},
    {"icon": Icons.access_time, "label": "设置"},
  ];

  final List<Widget> _pages = [
    const Home(),
    const RecipePage(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => Stack(children: [
            _pages[Controller.c.tabIndex.value],
            CustomTabBar()
          ])), // 切换不同页面
      floatingActionButton: const FloatBtn(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
