// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:calorie/page/survey/page5/chart.dart';

class SurveyPage5 extends StatefulWidget {
  final int weightType;// 0为公斤，1为英镑
  final int currentKg;
  final int currentLbs;
  final int targetKg;
  final int targetLbs;
  const SurveyPage5({
    super.key,
    required this.weightType,
    required this.currentKg,
    required this.currentLbs,
    required this.targetKg,
    required this.targetLbs,
  });

  @override
  _SurveyPage5State createState() => _SurveyPage5State();
}

class _SurveyPage5State extends State<SurveyPage5> {
  double selectedWeight = 0.4;
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    int displayCurrent = widget.weightType==0?widget.currentKg:widget.currentLbs;
    int displayTarget = widget.weightType==0?widget.targetKg:widget.targetLbs;
    String unit = widget.weightType==0?'kg':'lbs';
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(height: 40),
          Text('计划分析表',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          Stack(
            children: [
              _buildWeightChart(),
              Positioned(
                top:33,
                child:Container(
                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                  decoration: BoxDecoration(color: const Color.fromARGB(255, 252, 138, 130),borderRadius: BorderRadius.circular(20)),
                  child: Text('$displayCurrent $unit',style: TextStyle(color: Colors.white,fontSize: 12),),
                ),
              ),
              Positioned(
                top:3,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: const Color.fromARGB(150, 255, 221, 219),borderRadius: BorderRadius.circular(20)),
                      child:Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(color: const Color.fromARGB(255, 241, 21, 6),borderRadius: BorderRadius.circular(10)),
                      )  
                    )
                  ],
                ) 
              ),
              Positioned(
                bottom:33,
                right: 0,
                child:Container(
                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                  decoration: BoxDecoration(color: const Color.fromARGB(255, 79, 181, 255),borderRadius: BorderRadius.circular(20)),
                  child: Text('$displayTarget $unit',style: TextStyle(color: Colors.white,fontSize: 12),),
                ),
              ),
              Positioned(
                bottom:3,
                right:0,
                child: Container(
                  padding:const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: const Color.fromARGB(149, 200, 230, 255),borderRadius: BorderRadius.circular(20)),
                  child:Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(color: const Color.fromARGB(255, 29, 153, 241),borderRadius: BorderRadius.circular(10)),
                    )  
                  )
              ),
            ],
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('今天',style: TextStyle(color:const Color.fromARGB(255, 111, 111, 111)),),
              Text('第100天',style: TextStyle(color:const Color.fromARGB(255, 111, 111, 111)),)
            ],
           ),
           const SizedBox(height: 16),
            Center(
              child: Text(
                "${selectedWeight.toStringAsFixed(1)}kg",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            Slider(
              value: selectedWeight,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              label: "${selectedWeight.toStringAsFixed(1)}kg",
              onChanged: (value) {
                setState(() {
                  selectedWeight = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("0.1kg"), Text("1.0kg")],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text("👍 Recommended: Est. 578 days, avg. ${selectedWeight.toStringAsFixed(1)}kg/week"),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text("Next"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),);
  
  }

  Widget _buildWeightChart() {
    return Container(
      height: 150,
    child: WeightGoalChart(),) ;
    
  }

}

  Widget _buildWeightLabel(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

 