import 'package:calorie/page/survey/result/healthStatusCard.dart';
import 'package:calorie/page/survey/result/nutritionCard.dart';
import 'package:calorie/store/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/buttonX/index.dart';

class SurveyResult extends StatefulWidget {
  const SurveyResult({
    super.key,
  });
  @override
  State<SurveyResult> createState() => _SurveyResultState();
}

class _SurveyResultState extends State<SurveyResult> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1), // 背景色
      body: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopBanner(),
                HealthStatusCard(),
                DailyIntakeSection(),
              ],
            ),
          ),
      bottomNavigationBar: buildCompleteButton(context,'让我们开始吧！'.tr,(){
        Navigator.pushNamed(context, '/');
       }),
    );
  }
}

/// 顶部形象 + 文字
class TopBanner extends StatelessWidget {
  const TopBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 150,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 194, 229, 255),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top:60.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("恭喜！", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("你的定制计划已准备就绪！", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}




/// 每日推荐摄入量
class DailyIntakeSection extends StatelessWidget {
  const DailyIntakeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 249, 246, 249),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("每日摄入", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              height: 350,
              child: GridView.count(
                padding: EdgeInsets.all(2),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true, 
                physics: NeverScrollableScrollPhysics(), // 禁用滚动
                children: [
                  NutritionCard(title: "卡路里", value: "1616", percentage: 0.6, color: Colors.green),
                  NutritionCard(title: "Carbs", value: "183", percentage: 0.6, color: Colors.orange),
                  NutritionCard(title: "Protein", value: "120", percentage: 0.6, color: Colors.red),
                  NutritionCard(title: "Fats", value: "44", percentage: 0.6, color: Colors.blue),
                ],
              ),
            )    
          ],
        ),
      ),
    );
  }
}






    