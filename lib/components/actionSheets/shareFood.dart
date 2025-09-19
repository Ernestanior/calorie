

import 'package:calorie/common/icon/index.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:calorie/common/util/utils.dart';

final GlobalKey shareFoodKey = GlobalKey();

class ShareFoodSheet extends StatefulWidget {
  const ShareFoodSheet({super.key});
  @override
  State<ShareFoodSheet> createState() => _ShareFoodSheetState();
}

class _ShareFoodSheetState extends State<ShareFoodSheet>  {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color.fromARGB(255, 250, 249, 255)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(children: [
        Text(
          'SHARE'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        RepaintBoundary(
            key: shareFoodKey,
            child:Container(
              decoration: BoxDecoration(color: Color.fromARGB(255, 250, 249, 255)),
              child:   Column(
              children: [
                const SizedBox(height: 20),
                // 图片 + 标题
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        Controller.c.foodDetail['sourceImg'], // 这里换成你的食物图片
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        left: 20,
                        bottom: 10,
                        child: Container(
                          child: const Column(
                            children: [
                              Text(
                                "Sausage and Vegetables",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/image/logo.png',
                      width: 26,
                    ),
                    const Text("Vita AI",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                // 营养信息
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      _buildInfoCard(
                          "CALORIE".tr,
                          Controller.c.foodDetail['detectionResultData']
                              ['total']['calories'],
                          'kcal',
                          AliIcon.calorie2,
                          const Color.fromARGB(255, 255, 122, 82)),
                      _buildInfoCard(
                          "CARBS".tr,
                          Controller.c.foodDetail['detectionResultData']
                              ['total']['carbs'],
                          'g',
                          AliIcon.dinner4,
                          Colors.blueAccent),
                      _buildInfoCard(
                          "PROTEIN".tr,
                          Controller.c.foodDetail['detectionResultData']
                              ['total']['protein'],
                          'g',
                          AliIcon.fat,
                          Colors.orangeAccent),
                      _buildInfoCard(
                          "FATS".tr,
                          Controller.c.foodDetail['detectionResultData']
                              ['total']['fat'],
                          'g',
                          AliIcon.meat2,
                          Colors.redAccent),
                      _buildInfoCard(
                          "SUGAR".tr,
                          Controller.c.foodDetail['detectionResultData']
                              ['total']['sugar'],
                          'g',
                          AliIcon.sugar2,
                          const Color.fromARGB(255, 4, 247, 255)),
                      _buildInfoCard(
                          "FIBER".tr,
                          Controller.c.foodDetail['detectionResultData']
                              ['total']['fiber'],
                          'g',
                          AliIcon.fiber,
                          const Color.fromARGB(255, 64, 255, 83)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            )),
           
            ) ,
             
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: ()=>SharePng(shareFoodKey,type:'ins'),
                      child:Column(
                      children: [
                        Image.asset(
                          'assets/image/ins.png',
                          width: 50,
                        ),
                        const Text("Instagram", style: TextStyle(fontSize: 12)),
                      ],
                    ) ,
                    )
                    ,
                    GestureDetector(
                      onTap: ()=>SharePng(shareFoodKey,type:'facebook'),
                      child:Column(
                      children: [
                        Image.asset(
                          'assets/image/facebook.png',
                          width: 47,
                        ),
                        SizedBox(height: 3,),
                        const Text("Facebook", style: TextStyle(fontSize: 12)),
                      ],
                    ) ,
                    ),
                    _buildShareButton(
                        Image.asset(
                          'assets/image/wechat.png',
                          width: 31,
                        ),
                        "WECHAT".tr,onPress:()=>SharePng(shareFoodKey,type:'wx'),
                        color: const Color.fromARGB(255, 9, 194, 15)
                          ),
                    _buildShareButton(
                        Image.asset(
                          'assets/image/share.png',
                          width: 30,
                        ),
                        "OTHER".tr,onPress:()=>SharePng(shareFoodKey)
                          ),
                  ],
                ),
              
      ]),
    );
  }

  Widget _buildInfoCard(String title, Object? value, String unit, IconData icon,
      Color iconColor) {
    return Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(31, 155, 155, 155),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ]),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(icon, size: 24, color: iconColor),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Color.fromARGB(176, 0, 0, 0))),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    text: "$value ",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                          text: unit,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 120, 120, 120)))
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildShareButton(Widget icon, String text, {Color? color, void Function()? onPress}) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(31, 122, 122, 122),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
            color: color ?? Colors.white,
          ),
          child: icon,
        ),
        const SizedBox(height: 3),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    ),
    ) ;
  }
}
