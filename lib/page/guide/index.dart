import 'package:calorie/components/languageSelector/index.dart';
import 'package:calorie/components/video/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({
    super.key,
  });
  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(height: 70),
        OnboardingVideo(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [const LanguageSelector()],
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'AI_CALORIE_TRACKING'.tr,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: const Color.fromARGB(197, 0, 0, 0)),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xC5291B30),
            minimumSize: const Size(300, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/survey', // 要跳转的目标页面名称
            );
          },
          child: Text("CUSTOMIZE_MY_PLAN".tr,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home', // 要跳转的目标页面名称
                (route) => false, // 清除所有旧路由
              );
            },
            child: Text(
              'SKIP'.tr,
              style: TextStyle(
                decoration: TextDecoration.underline, // 下划线
                decorationColor:
                    const Color.fromARGB(255, 0, 0, 0), // 可选，设置下划线颜色
                decorationThickness: 2, // 可选，设置下划线粗细
                color: Colors.black,
                fontSize: 16,
              ),
            ))
      ],
    ));
  }
}
