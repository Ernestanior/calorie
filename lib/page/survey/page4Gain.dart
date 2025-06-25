import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_picker/wheel_picker.dart';


class SurveyPage4Gain extends StatefulWidget {
  final int kg;
  final int lbs;
  final int initKg;
  final int initLbs;
  final int unitType;
  final Function onChangeKg;
  final Function onChangeLbs;
  final Function onChangeType;
  const SurveyPage4Gain({super.key,required this.kg,required this.lbs,required this.initKg,required this.initLbs,required this.unitType,required this.onChangeKg,required this.onChangeLbs,required this.onChangeType});
  @override
  State<SurveyPage4Gain> createState() => _SurveyPage4GainState();
}

class _SurveyPage4GainState extends State<SurveyPage4Gain> {


  late var kgWheel= WheelPickerController(itemCount: 250,initialIndex: widget.kg==0?0:widget.kg-widget.initKg);
  late var poundWheel= WheelPickerController(itemCount: 500,initialIndex: widget.lbs==0?0:widget.lbs-widget.initLbs);
  static const textStyle = TextStyle(fontSize: 15, height: 2,fontWeight: FontWeight.w600);

  double getLeftPosition(int index) {
    return index * 150; // 控制白色方框的移动位置
  }
  @override
  Widget build(BuildContext context) {
    List weightList=[{'value':'kg','label':'KILOGRAM'.tr,'unit':'KG'.tr},{'value':'lbs','label':'POUND'.tr,'unit':'LBS'.tr},];
    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('YOUR_TARGET_WEIGHT'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
         Visibility(
            visible:  widget.unitType==0,
            child: SizedBox(
            height: 400,
            child: WheelPicker(
                looping: false,
                builder: (context, index) => Text("${index+widget.initKg} ${weightList[widget.unitType]['unit']}", style: textStyle),
                controller: kgWheel,
                selectedIndexColor: Colors.black,
                onIndexChanged: (index,interactionType) {
                  widget.onChangeKg(index+widget.initKg);
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
            visible:  widget.unitType==1,
            child: SizedBox(
            height: 400,
            child:
              WheelPicker(
                looping: false,
                builder: (context, index) => Text("${index+widget.initLbs} ${weightList[widget.unitType]['unit']}", style: textStyle),
                controller: poundWheel,
                selectedIndexColor: Colors.black,
                onIndexChanged: (index,interactionType) {
                  widget.onChangeLbs(index+widget.initLbs);
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
