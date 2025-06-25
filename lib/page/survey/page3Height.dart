import 'package:calorie/common/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_picker/wheel_picker.dart';


class SurveyPage3Height extends StatefulWidget {
  final int unitType;

  final int height;
  final Function onChangeHeight;

  const SurveyPage3Height({super.key,required this.unitType,required this.height,required this.onChangeHeight});
  @override
  State<SurveyPage3Height> createState() => _SurveyPage3HeightState();
}

class _SurveyPage3HeightState extends State<SurveyPage3Height> {

  List unitList=[{'value':'metric','label':'METRIC'.tr,'weightUnit':'KG'.tr,'heightUnit':'CM'.tr},{'value':'imperial','label':'IMPERIAL'.tr,'weightUnit':'LBS'.tr,'heightUnit':'IN'.tr},];
  static const textStyle = TextStyle(fontSize: 18, height: 2,fontWeight: FontWeight.w600);

  double getLeftPosition(int index) {
    return index * 150; // 控制白色方框的移动位置
  }
  @override
  Widget build(BuildContext context) {

    Map<String, int>feetInch= inchesToFeetAndInches(widget.height);
    int feet= feetInch['feet'] ?? 1;
    int inches= feetInch['inches'] ?? 1;
    late var cmWheel= WheelPickerController(itemCount: 150,initialIndex: widget.height-100);
    late var feetWheel= WheelPickerController(itemCount: 10,initialIndex: feet );
    late var inchWheel= WheelPickerController(itemCount: 12,initialIndex: inches );

    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('YOUR_HEIGHT'.tr,
          style:const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible:  widget.unitType==0,
                child: SizedBox(
                  height: 400,
                  width: 170,
                  child: WheelPicker(
                    looping: false,
                    builder: (context, index) => Text("${index+100} ${'CM'.tr}", style: textStyle),
                    controller: cmWheel,
                    selectedIndexColor: Colors.black,
                    onIndexChanged: (index,interactionType) {
                      // setState(() {
                      //   initHeight=index+100;
                      // });
                      widget.onChangeHeight(index+100);
                    },
                    style: WheelPickerStyle(
                      itemExtent: textStyle.fontSize! * textStyle.height!,
                      squeeze: 1.1,
                      diameterRatio: 1,
                      surroundingOpacity: 0.15,
                      magnification: 1.2,
                    ),
                  ),
              ),),
              Visibility(
                visible:  widget.unitType==1,
                child: SizedBox(
                  height: 400,
                  width: 170,
                  child: WheelPicker(
                    looping: false,
                    builder: (context, index) => Text("$index ${'FEET'.tr}", style: textStyle),
                    controller: feetWheel,
                    selectedIndexColor: Colors.black,
                    onIndexChanged: (index,interactionType) {
                      // setState(() {
                      //   initHeight=index+100;
                      // });
                      widget.onChangeHeight(index*12+inches);
                    },
                    style: WheelPickerStyle(
                      itemExtent: textStyle.fontSize! * textStyle.height!,
                      squeeze: 1.1,
                      diameterRatio: 1,
                      surroundingOpacity: 0.15,
                      magnification: 1.2,
                    ),
                  ),
              ),),
                Visibility(
                visible:  widget.unitType==1,
                child: SizedBox(
                  height: 400,
                  width: 170,
                  child: WheelPicker(
                    looping: false,
                    builder: (context, index) => Text("$index ${'INCH'.tr}", style: textStyle),
                    controller: inchWheel,
                    selectedIndexColor: Colors.black,
                    onIndexChanged: (index,interactionType) {
                      // setState(() {
                      //   initHeight=index+100;
                      // });
                      widget.onChangeHeight(feet*12+index);
                    },
                    style: WheelPickerStyle(
                      itemExtent: textStyle.fontSize! * textStyle.height!,
                      squeeze: 1.1,
                      diameterRatio: 1,
                      surroundingOpacity: 0.15,
                      magnification: 1.2,
                    ),
                  ),
              ),),
            
            ],),
          ],)
    );
  }
}
