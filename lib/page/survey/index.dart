import 'dart:async';
import 'package:calorie/common/icon/index.dart';
import 'package:calorie/page/survey/page1.dart';
import 'package:calorie/page/survey/page1Plus.dart';
import 'package:calorie/page/survey/page2.dart';
import 'package:calorie/page/survey/page3.dart';
import 'package:calorie/page/survey/page4Gain.dart';
import 'package:calorie/page/survey/page4Lose.dart';
import 'package:calorie/page/survey/page5/index.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiStepForm extends StatefulWidget {
  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {

  StreamController<String> _streamController = StreamController<String>();
  List<String> _messages = [];
  
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String gender = 'male';
  int age = 20;
  int targetSelected = 0; // 0为减重，1为维持当前，2为增重
  int timeSelected = 0; // 0为每周0-2次，1为每周3-5次，2为每周6+次、
  int dietSelected = 0; //0为荤食，1为素食
  int height = 170;
  int weightType=0; // 0为公斤，1为英镑
  int currentKg=60;
  int currentLbs=120;
  int targetKg=0;
  int targetLbs=0;
  double planWeight=0.4;

  void _finish()async {


    var arguments = {
      "id":Controller.c.user['id'],
      "age": age,
      "gender": gender=='male'?1:2,
      "lang": "zh_CN",
      "heightCm": height,
      "currentWeightKg": currentKg,
      "targetWeightKg": targetKg,
      "weeklyWeightChangeKg": planWeight,
      "activityFactor": timeSelected==0?1.2:timeSelected==1?1.4:1.6,
    };
    Get.toNamed("/surveyAnalysis", arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    // 动态生成 pages
    List<Widget> pages = [
      SurveyPage1(
        gender:gender,
        onChange:(value)=>setState(()=>gender=value)
      ),
      SurveyPage1Plus(
        age:age,
        onChange:(value){
          setState(()=>age=value);
          }
      ),
      // SurveyResult(),
      SurveyPage2(
        height:height,
        onChange:(value)=>setState(()=>height=value)
      ),
      SurveyPage3(
        weightType:weightType,
        kg:currentKg,
        lbs:currentLbs,
        onChangeKg:(value)=>setState(()=>currentKg=value),
        onChangeLbs:(value)=>setState(()=>currentLbs=value),
        onChangeType:(value)=>setState(()=>weightType=value)
      ),
      _buildPage(
        "你的目标是什么?",
        [{'label':"减重",'icon':AliIcon.running},{'label':"维持现状",'icon':AliIcon.handle},{'label':"增重",'icon':AliIcon.milktea}],
        targetSelected,
        (value)=>setState(()=>targetSelected=value),
      ), 
      _buildPage(
        "你每周的锻炼程度?", 
        [{'label':"久坐，很少或偶尔锻炼",'icon':AliIcon.laptop},{'label':"每周运动3-8小时运动",'icon':AliIcon.shoes},{'label':"每周超过10h运动",'icon':AliIcon.dumbbell}],
        timeSelected,
        (value)=>setState(()=>timeSelected=value),
      ),
      // _buildPage(
      //   "你喜欢的饮食类型是", 
      //   [{'label':"无偏好",'icon':AliIcon.chicken},{'label':"纯素食",'icon':AliIcon.vegetable}],
      //   dietSelected,
      //   (value)=>setState(()=>dietSelected=value),
      // ),
    ];

    // 根据 targetSelected 添加 SurveyPage4Lose 或 SurveyPage4Gain
    if (targetSelected == 2) {
      pages.add(SurveyPage4Gain(
        weightType: weightType,
        initKg: currentKg+1,
        initLbs: currentLbs+1,
        kg: targetKg,
        lbs: targetLbs,
        onChangeKg: (value) => setState(() => targetKg = value),
        onChangeLbs: (value) => setState(() => targetLbs = value),
        onChangeType: (value) => setState(() => weightType = value),
      ));
       pages.add(SurveyPage5(
        targetSelected:targetSelected,
        weightType: weightType,
        currentKg: currentKg,
        currentLbs: currentLbs,
        targetKg: targetKg,
        targetLbs: targetLbs,
        selectedWeight:planWeight,
        onChange: (value)=>setState(()=>planWeight=value)
      ));
    } else if (targetSelected == 0) {
      pages.add(SurveyPage4Lose(
        weightType: weightType,
        initKg: currentKg,
        initLbs: currentLbs,
        kg: targetKg,
        lbs: targetLbs,
        onChangeKg: (value) => setState(() => targetKg = value),
        onChangeLbs: (value) => setState(() => targetLbs = value),
        onChangeType: (value) => setState(() => weightType = value),
      ));
      pages.add(SurveyPage5(
        targetSelected:targetSelected,
        weightType: weightType,
        currentKg: currentKg,
        currentLbs: currentLbs,
        targetKg: targetKg,
        targetLbs: targetLbs,
        selectedWeight:planWeight,
        onChange: (value)=>setState(()=>planWeight=value)
      ));
    }

    // 添加之后的固定页面
    pages.addAll([


    ]);
    return Scaffold(
      body: Container(
        padding:const EdgeInsets.symmetric(horizontal: 5),        
        child: Column(
        children: [
          const SizedBox(height: 68,),
          Row(
            children: [
              IconButton(
                icon: const Icon(AliIcon.back, size: 45,color: Colors.black,),
                onPressed: _currentPage > 0 ? _prevPage : null,
              ),
            ],
          ),    
          const SizedBox(height: 18,),        // 返回按钮
          // 添加动画的进度条
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
                begin: (_currentPage + 1) / pages.length,
                end: (_currentPage + 1) / pages.length),
            duration: const Duration(milliseconds: 200), // 进度条动画时间
            builder: (context, value, child) {
              return SizedBox(
                width: 280,
                child: LinearProgressIndicator(
                minHeight:10,
                borderRadius:BorderRadius.circular(10),
                value: value,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              ),
              );
            },
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: pages
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
            ),
            onPressed: _currentPage < pages.length - 1 ? _nextPage : _finish,
            child: _currentPage < pages.length - 1 ? const Text("下一步",
                style: TextStyle(fontSize: 18, color: Colors.white)):const Text("开始定制计划",
                style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold)),
          ),
          ),
          // 下一步按钮
          const SizedBox(height: 30,)
        ],
      ),
      ),
    );
  }

  Widget _buildPage(String title, List options, int PageIndex,Function onChange) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),        
          const SizedBox(height: 20),
          Column(
            children: options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value['label'];
              IconData icon = entry.value['icon'];
              bool isSelected = PageIndex == index;

              return GestureDetector(
                onTap: () => onChange(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color.fromARGB(255, 187, 223, 255) : const Color.fromARGB(255, 239, 249, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(children: [
                      Icon(icon,size: 24,),
                      SizedBox(width: 10,),
                      Text(
                        option,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],) ,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _updatePages() {
    int maxPages = targetSelected == 1 ? 5 : 6; // 维持现状少一个页面

    if (_currentPage >= maxPages) {
      _pageController.jumpToPage(maxPages - 1);
      setState(() {
        _currentPage = maxPages - 1;
      });
    }
  }



  void _nextPage() {
    if (_currentPage < _pageController.positions.first.maxScrollExtent) {
      _pageController.nextPage(duration: Duration(milliseconds: 100), curve: Curves.ease);
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: Duration(milliseconds: 100), curve: Curves.ease);
    }
  }

}

