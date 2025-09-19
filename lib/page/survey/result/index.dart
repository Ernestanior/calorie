import 'package:calorie/network/api.dart';
import 'package:calorie/page/survey/result/healthStatusCard.dart';
import 'package:calorie/page/survey/result/nutritionCard.dart';
import 'package:calorie/store/store.dart';
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
  List advice = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData()async {
    final res =await getUserDietaryAdvice();
      setState(() {
        advice=res;
      });
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1), // 背景色
      body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopBanner(),
                const HealthStatusCard(),
                const DailyIntakeSection(),
                advice.isNotEmpty ? DietAdvice(advice:advice):const SizedBox.shrink()
              ],
            ),
          ),
      bottomNavigationBar: buildCompleteButton(context,'LETS_START'.tr,(){
        // Navigator.pushNamed(context, '/');
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home', // 目标页面的路由名称
          (route) => false, // 移除所有旧路由
        );
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
         Padding(
          padding: const EdgeInsets.only(top:70.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("CONGRATULATIONS".tr, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("PERSONALIZED_PLAN_IS_READY_SHORT".tr, style: const TextStyle(fontSize: 16)),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 249, 246, 249),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("DAILY_INTAKE".tr, style:const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            SizedBox(height: 10,),
            SizedBox(
              height: 350,
              child: GridView.count(
                padding: const EdgeInsets.all(0),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true, 
                physics: const NeverScrollableScrollPhysics(), // 禁用滚动
                children: [
                  NutritionCard(title: "CALORIE".tr, unit:'KCAL'.tr, total: Controller.c.user['dailyCalories']!, percentage: 0.6, color: Colors.green),
                  NutritionCard(title: "CARBS".tr, unit:'G'.tr, total: Controller.c.user['dailyCarbs'], percentage: 0.6, color: Colors.orange),
                  NutritionCard(title: "PROTEIN".tr, unit:'G'.tr, total: Controller.c.user['dailyProtein'], percentage: 0.6, color: Colors.red),
                  NutritionCard(title: "FATS".tr, unit:'G'.tr, total: Controller.c.user['dailyFats'], percentage: 0.6, color: Colors.blue),
                ],
              ),
            )    
          ],
        ),
      ),
    );
  }
}

/// 每日推荐摄入量
class DietAdvice extends StatelessWidget {
  final List advice;
  const DietAdvice({required this.advice, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 249, 246, 249),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("LITTLE_ADVICE".tr, style:const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
              child: Column(children:advice.map<Widget>((value)=>Column(children: [
                  Text("· $value",style: const TextStyle(fontSize: 13,color: Color.fromARGB(255, 80, 80, 80)),),
                  const SizedBox(height: 10,)
              ] )).toList(),
            ))
           ],
        ),
      ),
    );
  }
}






    