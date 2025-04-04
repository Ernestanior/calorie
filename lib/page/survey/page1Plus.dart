import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_picker/wheel_picker.dart';


class SurveyPage1Plus extends StatefulWidget {
  final int age;
  final Function onChange;
  const SurveyPage1Plus({super.key,required this.age,required this.onChange});
  @override
  State<SurveyPage1Plus> createState() => _SurveyPage1PlusState();
}

class _SurveyPage1PlusState extends State<SurveyPage1Plus> {
    late int initAge=widget.age;
    late var ageWheel= WheelPickerController(itemCount: 100,initialIndex: initAge-15);
    static const textStyle = TextStyle(fontSize: 18, height: 2,fontWeight: FontWeight.w600);

// late int initAge;
//   late WheelPickerController ageWheel;

//   @override
//   void initState() {
//     super.initState();
//     initAge = widget.age;
//     ageWheel = WheelPickerController(itemCount: 100, initialIndex: initAge - 15);
//   }

//   @override
//   void didUpdateWidget(covariant SurveyPage1Plus oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.age != oldWidget.age) { 
//       setState(() {
//         initAge = widget.age; // **更新 initAge**
//         ageWheel = WheelPickerController(itemCount: 100, initialIndex: initAge - 15); // **更新 WheelPicker**
//       });
//     }
//   }



  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text('YOUR_AGE',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          SizedBox(
            height: 400,
            child: WheelPicker(
                  looping: false,
                  builder: (context, index) => Text("${index+15} ${'YEARS'.tr}", style: textStyle),
                  controller: ageWheel,
                  selectedIndexColor: Colors.black,
                  onIndexChanged: (index,interactionType) {
                    // setState(() {
                    //   initAge=index+15;
                    // });
                    widget.onChange(index+15);
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
