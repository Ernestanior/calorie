import 'package:calorie/common/icon/index.dart';
import 'package:calorie/common/tabbar/floatBtn.dart';
import 'package:calorie/page/home/index.dart';
import 'package:calorie/page/profile/index.dart';
import 'package:calorie/page/recipe/index.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {

  final List<Map<String, dynamic>> _tabs = [
    {"icon": AliIcon.check, "label": "记录","path":Home()},
    {"icon": AliIcon.recipe3, "label": "食谱","path":Recipe()},
    {"icon": AliIcon.mine3, "label": "我","path":Profile()},
  ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left:20,
      right:20,
      child:
      SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 左边 Tabs
             
        Container(
              width: 280,
              height: 65,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(234, 253, 251, 255),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(color: Colors.white,width: 2)
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double tabWidth = constraints.maxWidth / _tabs.length;
                  return Stack(
                    children: [
                      // 灰色滑块背景
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        left: Controller.c.tabIndex.value * tabWidth,
                        top: 0,
                        bottom: 0,
                        width: tabWidth,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(90, 205, 205, 205),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),

                      // Tabs 内容
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(_tabs.length, (index) {
                          final tab = _tabs[index];
                          final isSelected = index == Controller.c.tabIndex.value;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => tab['path'],
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  // 透明度渐变
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(milliseconds: 400), // 动画时长
                              ),
                            );
                            Controller.c.tabIndex(index);
                              
                            },
                            child: Container(
                              decoration: const BoxDecoration(color: Colors.transparent),
                              width: tabWidth,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 3),

                                  Icon(
                                    tab["icon"],
                                    color: isSelected
                                        ? Colors.black
                                        : const Color.fromARGB(255, 131, 120, 176),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    tab["label"],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
FloatBtn()
            // 右边加号按钮
            // Container(
            //   width: 60,
            //   height: 60,
            //   decoration: const BoxDecoration(
            //     color: Colors.black,
            //     shape: BoxShape.circle,
            //   ),
            //   child: const Icon(AliIcon.camera_fill, color: Colors.white, size: 29),
            // ),
          ],
        ),
      ),
    );
  }
}
