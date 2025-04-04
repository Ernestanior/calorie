// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:calorie/page/survey/page5/chartGain.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:calorie/page/survey/page5/chartLose.dart';

class SurveyPage5 extends StatefulWidget {
  final int targetSelected;
  final int weightType;// 0为公斤，1为英镑
  final int currentKg;
  final int currentLbs;
  final int targetKg;
  final int targetLbs;
  final double selectedWeight;
  final Function onChange;
  const SurveyPage5({
    super.key,
    required this.weightType,
    required this.targetSelected,
    required this.currentKg,
    required this.currentLbs,
    required this.targetKg,
    required this.targetLbs,
    required this.selectedWeight,
    required this.onChange
  });

  @override
  _SurveyPage5State createState() => _SurveyPage5State();
}

class _SurveyPage5State extends State<SurveyPage5> {
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    int displayCurrent = widget.weightType==0?widget.currentKg:widget.currentLbs;
    int displayTarget = widget.weightType==0?widget.targetKg:widget.targetLbs;
    String unit = widget.weightType==0?'kg':'lbs';
    int weeks = ((displayTarget-displayCurrent).abs()/widget.selectedWeight).ceil();
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const SizedBox(height: 40),
          const Text('每周计划',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Visibility(
            visible: widget.targetSelected==0,
            child: WeightGoalChartLose(displayCurrent: displayCurrent,displayTarget: displayTarget,unit: unit,),
          ),
          Visibility(
            visible: widget.targetSelected==2,
            child: WeightGoalChartGain(displayCurrent: displayCurrent,displayTarget: displayTarget,unit: unit,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('今天',style: TextStyle(color:Color.fromARGB(255, 111, 111, 111)),),
              Text('${weeks}周',style: TextStyle(color:Color.fromARGB(255, 111, 111, 111)),)
            ],
           ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.selectedWeight.toStringAsFixed(1)} $unit",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ) ,
            Slider(
              value: widget.selectedWeight,
              min: 0.1,
              max: unit=='kg'? 1.0:2.5,
              divisions: unit=='kg'?9:24,
              label: "${widget.selectedWeight.toStringAsFixed(1)} $unit",
              activeColor:Colors.blue,
              onChanged: (value) {
                // setState(() {
                //   widget.selectedWeight = value;
                // });
                widget.onChange(value);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("0.1 $unit"), Text("${unit=='kg'?'1.0':'2.5'} $unit")],
            ),
            const SizedBox(height: 50),
            Center(
              child: Text("让我们坚持${weeks}周 !",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            )
            ],
        ),);
  
  }


}

 