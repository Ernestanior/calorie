import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:get/get.dart';
import 'package:wheel_picker/wheel_picker.dart';

class SurveyPage3Weight extends StatefulWidget {
  final int unitType;

  final int weight;
  final Function onChangeWeight;

  final Function onChangeType;
  const SurveyPage3Weight(
      {super.key,
      required this.unitType,
      required this.weight,
      required this.onChangeWeight,
      required this.onChangeType});
  @override
  State<SurveyPage3Weight> createState() => _SurveyPage3WeightState();
}

class _SurveyPage3WeightState extends State<SurveyPage3Weight> {
  RulerPickerController? _rulerPickerController;
  num currentWeight = Controller.c.user['currentWeight'];
  String unitType = Controller.c.user['unitType'] == 0 ? 'kg' : 'lbs';

  List<RulerRange> ranges = const [
    RulerRange(begin: 0, end: 100, scale: 0.1),
  ];

  double getLeftPosition(int index) {
    return index * 150; // 控制白色方框的移动位置
  }

  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: currentWeight);
  }

  @override
  Widget build(BuildContext context) {
    List unitList = [
      {'value': 'metric', 'label': 'METRIC'.tr, 'weightUnit': 'KG'.tr},
      {'value': 'imperial', 'label': 'IMPERIAL'.tr, 'weightUnit': 'LBS'.tr},
    ];

    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text('YOUR_WEIGHT'.tr,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

            SizedBox(
              height: 80,
            ),
            Row(
              textBaseline: TextBaseline.alphabetic,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  currentWeight.toStringAsFixed(1),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  unitType,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
            RulerPicker(
              controller: _rulerPickerController,
              onBuildRulerScaleText: (index, value) {
                return value.toInt().toString();
              },
              ranges: ranges,
              rulerScaleTextStyle: TextStyle(color: Colors.black),
              scaleLineStyleList: const [
                ScaleLineStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 1.5,
                    height: 30,
                    scale: 0),
                ScaleLineStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 1,
                    height: 25,
                    scale: 5),
                ScaleLineStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 1,
                    height: 15,
                    scale: -1)
              ],
              onValueChanged: (value) {
                setState(() {
                  currentWeight = value;
                });
              },
              width: MediaQuery.of(context).size.width,
              height: 80,
              rulerMarginTop: 8,
            ),
            // Visibility(
            //   visible:  widget.unitType==0,
            //   child: SizedBox(
            //   height: 400,
            //   width: 170,
            //   child: WheelPicker(
            //     looping: false,
            //     builder: (context, index) => Text("$index ${unitList[widget.unitType]['weightUnit']}", style: textStyle),
            //     controller: kgWheel,
            //     selectedIndexColor: Colors.black,
            //     onIndexChanged: (index,interactionType) {
            //       widget.onChangeWeight(index);
            //     },
            //     style: WheelPickerStyle(
            //       itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
            //       squeeze: 1.1,
            //       diameterRatio: 1,
            //       surroundingOpacity: 0.15,
            //       magnification: 1.2,
            //     ),
            //   )
            //   )
            // ),
            // Visibility(
            //   visible: widget.unitType==1,
            //   child: SizedBox(
            //     height: 400,
            //     width: 170,
            //     child: WheelPicker(
            //       looping: false,
            //       builder: (context, index) => Text("$index ${unitList[widget.unitType]['weightUnit']}", style: textStyle),
            //       controller: poundWheel,
            //       selectedIndexColor: Colors.black,
            //       onIndexChanged: (index,interactionType) {
            //         widget.onChangeWeight(index);
            //       },
            //       style: WheelPickerStyle(
            //         itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
            //         squeeze: 1.1,
            //         diameterRatio: 1,
            //         surroundingOpacity: 0.15,
            //         magnification: 1.2,
            //       ),
            //     )
            //   ),),
          ],
        ));
  }
}
