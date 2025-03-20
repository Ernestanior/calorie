import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_picker/wheel_picker.dart';


class SurveyPage4Lose extends StatefulWidget {
  final int kg;
  final int lbs;
  final int initKg;
  final int initLbs;
  final int weightType;
  final Function onChangeKg;
  final Function onChangeLbs;
  final Function onChangeType;
  const SurveyPage4Lose({super.key,required this.kg,required this.lbs,required this.initKg,required this.initLbs,required this.weightType,required this.onChangeKg,required this.onChangeLbs,required this.onChangeType});
  @override
  State<SurveyPage4Lose> createState() => _SurveyPage4LoseState();
}

class _SurveyPage4LoseState extends State<SurveyPage4Lose> {

  List weightList=[{'value':'kg','label':'KILOGRAM'.tr,'unit':'KG'.tr},{'value':'lbs','label':'POUND'.tr,'unit':'LBS'.tr},];

  late var kgWheel= WheelPickerController(itemCount:widget.initKg,initialIndex: widget.initKg);
  late var poundWheel= WheelPickerController(itemCount: widget.initLbs,initialIndex: widget.initKg);
  static const textStyle = TextStyle(fontSize: 15, height: 2,fontWeight: FontWeight.w600);

  double getLeftPosition(int index) {
    return index * 150; // 控制白色方框的移动位置
  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text('YOUR_TARGET_WEIGHT',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
         Visibility(
            visible:  widget.weightType==0,
            child: SizedBox(
            height: 400,
            child: WheelPicker(
                looping: false,
                builder: (context, index) => Text("$index ${weightList[widget.weightType]['unit']}", style: textStyle),
                controller: kgWheel,
                selectedIndexColor: Colors.black,
                onIndexChanged: (index,interactionType) {
                  widget.onChangeKg(index);
                },
                style: WheelPickerStyle(
                  itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
                  squeeze: 1.1,
                  diameterRatio: 1,
                  surroundingOpacity: 0.15,
                  magnification: 1.2,
                ),
              )
            ) 
          ),
          Visibility(
            visible:  widget.weightType==1,
            child: SizedBox(
            height: 400,
            child:
              WheelPicker(
                looping: false,
                builder: (context, index) => Text("$index ${weightList[widget.weightType]['unit']}", style: textStyle),
                controller: poundWheel,
                selectedIndexColor: Colors.black,
                onIndexChanged: (index,interactionType) {
                  widget.onChangeLbs(index);
                },
                style: WheelPickerStyle(
                  itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
                  squeeze: 1.1,
                  diameterRatio: 1,
                  surroundingOpacity: 0.15,
                  magnification: 1.2,
                ),
              )
          ),)
        ],)
    );
  }
}
