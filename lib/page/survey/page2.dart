import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_picker/wheel_picker.dart';


class SurveyPage2 extends StatefulWidget {
  final int height;
  final Function onChange;
  const SurveyPage2({super.key,required this.height,required this.onChange});
  @override
  State<SurveyPage2> createState() => _SurveyPage2State();
}

class _SurveyPage2State extends State<SurveyPage2> {
    late int initHeight=widget.height;
    late var heightWheel= WheelPickerController(itemCount: 150,initialIndex: initHeight-100);
    static const textStyle = TextStyle(fontSize: 18, height: 2,fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text('YOUR_HEIGHT',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 40),
          SizedBox(
            height: 400,
            child: WheelPicker(
                  looping: false,
                  builder: (context, index) => Text("${index+100} ${'CM'.tr}", style: textStyle),
                  controller: heightWheel,
                  selectedIndexColor: Colors.black,
                  onIndexChanged: (index,interactionType) {
                    setState(() {
                      initHeight=index+100;
                    });
                  },
                  style: WheelPickerStyle(
                    itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
                    squeeze: 1.1,
                    diameterRatio: 1,
                    surroundingOpacity: 0.15,
                    magnification: 1.2,
                  ),
                  
                )
          ),

        ],)
    );
  }
}
