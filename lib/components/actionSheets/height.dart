import 'package:calorie/common/util/utils.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_picker/wheel_picker.dart';
import '../buttonX/index.dart';


class HeightSheet extends StatefulWidget {
  final int height;
  final Function onChange;
  const HeightSheet({super.key,required this.height,required this.onChange});
  @override
  State<HeightSheet> createState() => _HeightSheetState();
}

class _HeightSheetState extends State<HeightSheet> {
  late int initHeight=widget.height;

  static const textStyle = TextStyle(fontSize: 15, height: 2,fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    var cmWheel= WheelPickerController(itemCount: 150,initialIndex: initHeight-100);
    
    Map<String, int>feetInch= inchesToFeetAndInches(initHeight);
    int feet= feetInch['feet'] ?? 1;
    int inches= feetInch['inches'] ?? 1;
    var feetWheel= WheelPickerController(itemCount: 10,initialIndex: feet );
    var inchWheel= WheelPickerController(itemCount: 12,initialIndex: inches );

    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      height: 430,
      padding: const EdgeInsets.all(20),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 193, 193, 193),
              borderRadius: BorderRadius.circular(10)
            ),
            width: 40,
            height: 5,
          ),
          const SizedBox(height: 35,),
          Text(
            'SELECT_HEIGHT'.tr,
            style: const TextStyle(
                color: Color.fromARGB(255, 149, 149, 149),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              Visibility(
                visible: Controller.c.user['unitType']==0,
                child: SizedBox(
                  height: 200,
                  child: WheelPicker(
                        looping: false,
                        builder: (context, index) => Text("${index+100} ${'CM'.tr}", style: textStyle),
                        controller: cmWheel,
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
              ),
          
              Visibility(
                visible:  Controller.c.user['unitType']==1,
                child: SizedBox(
                  height: 200,
                  width: 170,
                  child: WheelPicker(
                    looping: false,
                    builder: (context, index) => Text("$index ${'FEET'.tr}", style: textStyle),
                    controller: feetWheel,
                    selectedIndexColor: Colors.black,
                    onIndexChanged: (index,interactionType) {
                        setState(() {
                          initHeight = index*12+inches;
                      });
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
                visible:  Controller.c.user['unitType']==1,
                child: SizedBox(
                  height: 200,
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
                      setState(() {
                         initHeight=feet*12+index;
                       });
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
          
            ],
          ),
          // Visibility(
          //   visible: Controller.c.user['unitType']==1,
          //   child: SizedBox(
          //     height: 200,
          //     child: WheelPicker(
          //           looping: false,
          //           builder: (context, index) => Text("${index+30} ${'INCH'.tr}", style: textStyle),
          //           controller: inchWheel,
          //           selectedIndexColor: Colors.black,
          //           onIndexChanged: (index,interactionType) {
          //             setState(() {
          //               initHeight=index+30;
          //             });
          //           },
          //           style: WheelPickerStyle(
          //             itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
          //             squeeze: 1.1,
          //             diameterRatio: 1,
          //             surroundingOpacity: 0.15,
          //             magnification: 1.2,
          //           ),
          //         )
          //   ),
          // ),
          
          buildCompleteButton(context,'CONFIRM'.tr,(){
            widget.onChange(initHeight);
            Get.back();
          })
        ],
      ),
    );
  }
}
