import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_picker/wheel_picker.dart';


class SurveyPage3 extends StatefulWidget {
  final int kg;
  final int lbs;
  final int weightType;
  final Function onChangeKg;
  final Function onChangeLbs;
  final Function onChangeType;
  const SurveyPage3({super.key,required this.kg,required this.lbs,required this.weightType,required this.onChangeKg,required this.onChangeLbs,required this.onChangeType});
  @override
  State<SurveyPage3> createState() => _SurveyPage3State();
}

class _SurveyPage3State extends State<SurveyPage3> {

  List weightList=[{'value':'kg','label':'KILOGRAM'.tr,'unit':'KG'.tr},{'value':'lbs','label':'POUND'.tr,'unit':'LBS'.tr},];

  late var kgWheel= WheelPickerController(itemCount: 250,initialIndex: widget.kg);
  late var poundWheel= WheelPickerController(itemCount: 500,initialIndex: widget.lbs);
  static const textStyle = TextStyle(fontSize: 18, height: 2,fontWeight: FontWeight.w600);

  double getLeftPosition(int index) {
    return index * 150; // 控制白色方框的移动位置
  }
  @override
  Widget build(BuildContext context) {
    print(widget.weightType);

    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text('YOUR_WEIGHT',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 300, // 宽度适配 3 个选项
              height: 45,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 239, 244, 255), // 背景色
                borderRadius: BorderRadius.circular(25), // 外围圆角
              ),
              child: Stack(
                children: [
                  // 移动的白色方框
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    left: getLeftPosition(widget.weightType),
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
                    children: weightList.asMap().entries.map((entry) {
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
                              color: widget.weightType == index
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
