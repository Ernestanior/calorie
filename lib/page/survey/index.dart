import 'package:calorie/common/icon/index.dart';
import 'package:calorie/page/survey/page1.dart';
import 'package:calorie/page/survey/page2.dart';
import 'package:calorie/page/survey/page3.dart';
import 'package:calorie/page/survey/page4Gain.dart';
import 'package:calorie/page/survey/page4Lose.dart';
import 'package:calorie/page/survey/page5/index.dart';
import 'package:flutter/material.dart';

class MultiStepForm extends StatefulWidget {
  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String gender = 'male';
  int targetSelected = 0; // 0为减重，1为维持当前，2为增重
  int timeSelected = 0; // 0为每周0-2次，1为每周3-5次，2为每周6+次
  int height = 170;
  int weightType=0; // 0为公斤，1为英镑
  int currentKg=60;
  int currentLbs=120;
  int targetKg=60;
  int targetLbs=120;
  @override
  Widget build(BuildContext context) {

    // 动态生成 pages
    List<Widget> pages = [
      SurveyPage1(
        gender:gender,
        onChange:(value)=>setState(()=>gender=value)
      ),
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
        ["减重", "维持现状", "增重"],
        targetSelected,
        (value)=>setState(()=>targetSelected=value),
      ), 
    ];

    // 根据 targetSelected 添加 SurveyPage4Lose 或 SurveyPage4Gain
    if (targetSelected == 2) {
      pages.add(SurveyPage4Gain(
        weightType: weightType,
        initKg: currentKg,
        initLbs: currentLbs,
        kg: targetKg,
        lbs: targetLbs,
        onChangeKg: (value) => setState(() => targetKg = value),
        onChangeLbs: (value) => setState(() => targetLbs = value),
        onChangeType: (value) => setState(() => weightType = value),
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
    }

    // 添加之后的固定页面
    pages.addAll([
      _buildPage(
        "你每周的锻炼程度?", 
        ["久坐，很少或偶尔锻炼", "每周运动3-8小时运动", "每周超过10h运动"],
        timeSelected,
        (value)=>setState(()=>targetSelected=value),
      ),
      SurveyPage5(
        weightType: weightType,
        currentKg: currentKg,
        currentLbs: currentLbs,
        targetKg: targetKg,
        targetLbs: targetLbs,
      )
    ]);


    return Scaffold(
      body: Container(
        padding:EdgeInsets.symmetric(horizontal: 5),        
        child: Column(
        children: [
          SizedBox(height: 68,),
          Row(
            children: [
              IconButton(
                icon: Icon(AliIcon.back, size: 45,color: Colors.black,),
                onPressed: _currentPage > 0 ? _prevPage : null,
              ),
            ],
          ),    
          SizedBox(height: 18,),        // 返回按钮
          // 添加动画的进度条
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
                begin: (_currentPage + 1) / pages.length,
                end: (_currentPage + 1) / pages.length),
            duration: Duration(milliseconds: 200), // 进度条动画时间
            builder: (context, value, child) {
              return Container(
                width: 280,
                child: LinearProgressIndicator(
                minHeight:10,
                borderRadius:BorderRadius.circular(10),
                value: value,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
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
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
            ),
            onPressed: _currentPage < pages.length - 1 ? _nextPage : null,
            child: const Text("Next",
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          ),
          // 下一步按钮
          SizedBox(height: 30,)
        ],
      ),
      ),
    );
  }

  Widget _buildPage(String title, List<String> options, int PageIndex,Function onChange) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text(title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),        
          SizedBox(height: 20),
          Column(
            children: options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              bool isSelected = PageIndex == index;

              return GestureDetector(
                onTap: () {
                  onChange(index);
                  // setState(() {
                  //   PageIndex = index;
                  // });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Color.fromARGB(255, 239, 244, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 18,
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
