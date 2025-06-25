import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_picker/wheel_picker.dart';


class SurveyPage3Weight extends StatefulWidget {
  final int unitType;

  final int weight;
  final Function onChangeWeight;

  final Function onChangeType;
  const SurveyPage3Weight({super.key,required this.unitType,required this.weight,required this.onChangeWeight,required this.onChangeType});
  @override
  State<SurveyPage3Weight> createState() => _SurveyPage3WeightState();
}

class _SurveyPage3WeightState extends State<SurveyPage3Weight> {

  static const textStyle = TextStyle(fontSize: 18, height: 2,fontWeight: FontWeight.w600);

  double getLeftPosition(int index) {
    return index * 150; // 控制白色方框的移动位置
  }
  @override
  Widget build(BuildContext context) {
    List unitList=[{'value':'metric','label':'METRIC'.tr,'weightUnit':'KG'.tr,'heightUnit':'CM'.tr},{'value':'imperial','label':'IMPERIAL'.tr,'weightUnit':'LBS'.tr,'heightUnit':'IN'.tr},];

    late var kgWheel= WheelPickerController(itemCount: 250,initialIndex: widget.weight);
    late var poundWheel= WheelPickerController(itemCount: 500,initialIndex:widget.weight);

    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('YOUR_WEIGHT'.tr,
          style:const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 300, // 宽度适配 3 个选项
              height: 45,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 227, 243, 255), // 背景色
                borderRadius: BorderRadius.circular(25), // 外围圆角
              ),
              child: Stack(
                children: [
                  // 移动的白色方框
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    left: getLeftPosition(widget.unitType),
                    child: Container(
                      width: 150, // 每个选项的宽度
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white, // 选中时的背景色
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4, // 阴影效果
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 选项文本
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: unitList.asMap().entries.map((entry) {
                      int index = entry.key;
                      String text = entry.value['label'];
                      return GestureDetector(
                        onTap: () {
                          widget.onChangeType(index);
                        },
                        child: Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: widget.unitType == index
                                  ? Colors.black
                                  : Colors.black54, // 选中变黑色，未选中变浅灰
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
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
                  builder: (context, index) => Text("$index ${unitList[widget.unitType]['weightUnit']}", style: textStyle),
                  controller: kgWheel,
                  selectedIndexColor: Colors.black,
                  onIndexChanged: (index,interactionType) {
                    widget.onChangeWeight(index);
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
                visible: widget.unitType==1,
                child: SizedBox(
                  height: 400,
                  width: 170,
                  child: WheelPicker(
                    looping: false,
                    builder: (context, index) => Text("$index ${unitList[widget.unitType]['weightUnit']}", style: textStyle),
                    controller: poundWheel,
                    selectedIndexColor: Colors.black,
                    onIndexChanged: (index,interactionType) {
                      widget.onChangeWeight(index);
                    },
                    style: WheelPickerStyle(
                      itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
                      squeeze: 1.1,
                      diameterRatio: 1,
                      surroundingOpacity: 0.15,
                      magnification: 1.2,
                    ),
                  )
                ),),
             ],),
          ],)
    );
  }
}
