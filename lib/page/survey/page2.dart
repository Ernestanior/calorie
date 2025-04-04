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
  // late int initHeight;
  // late WheelPickerController heightWheel;

  // @override
  // void initState() {
  //   super.initState();
  //   initHeight = widget.height;
  //   heightWheel = WheelPickerController(itemCount: 150, initialIndex: initHeight - 100);
  // }

  // @override
  // void didUpdateWidget(covariant SurveyPage2 oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.height != oldWidget.height) { 
  //     setState(() {
  //       initHeight = widget.height;
  //       heightWheel = WheelPickerController(itemCount: 150, initialIndex: initHeight-100); // **更新 WheelPicker**
  //     });
  //   }
  // }
    
    
    static const textStyle = TextStyle(fontSize: 18, height: 2,fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text('YOUR_HEIGHT',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          SizedBox(
            height: 400,
            child: WheelPicker(
                  looping: false,
                  builder: (context, index) => Text("${index+100} ${'CM'.tr}", style: textStyle),
                  controller: heightWheel,
                  selectedIndexColor: Colors.black,
                  onIndexChanged: (index,interactionType) {
                    // setState(() {
                    //   initHeight=index+100;
                    // });
                    widget.onChange(index+100);
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
