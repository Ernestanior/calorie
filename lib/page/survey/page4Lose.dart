
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_slider/wheel_slider.dart';


class SurveyPage4Lose extends StatefulWidget {

  final int unitType;
  final double weight;
  final int slideIndex;
  final Function onChangeSlides;
  const SurveyPage4Lose({super.key, required this.unitType, required this.weight, required this.onChangeSlides, required this.slideIndex});
  @override
  State<SurveyPage4Lose> createState() => _SurveyPage4LoseState();
}

class _SurveyPage4LoseState extends State<SurveyPage4Lose> {
  @override
  Widget build(BuildContext context) {
    double currentWeight=widget.weight!=0 ?widget.weight: (widget.unitType == 1 ? 150:70);
    String unitType = widget.unitType == 1 ? 'lbs' : 'kg';
    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('YOUR_TARGET_WEIGHT'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 120),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        (currentWeight).toStringAsFixed(1),
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
                            fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: unitType=='kg',
                    child:WheelSlider(
                    interval: 0.5,
                    totalCount:  200,
                    initValue: widget.slideIndex !=0 ? 100+widget.slideIndex* 0.5:99.5,
                    // totalCount:  (widget.weight*10).toInt(),
                    // initValue: widget.weight*10*0.5-0.5,
                    isInfinite: false,
                    enableAnimation: false,
                    onValueChanged: (val) {
                      widget.onChangeSlides((val*2 - 200).toInt());
                    },
                    hapticFeedbackType: HapticFeedbackType.selectionClick,
                  ), 
                  ),
                  Visibility(
                    visible: unitType=='lbs',
                    child:WheelSlider(
                    interval: 0.5,
                    totalCount: 400,
                    initValue:   widget.slideIndex !=0 ? 200+widget.slideIndex* 0.5:199.5,
                    // totalCount: (widget.weight*10 ).toInt(),
                    // initValue: widget.weight*10*0.5-0.5 ,
                    isInfinite: false,
                    enableAnimation: false,
                    onValueChanged: (val) {
                      widget.onChangeSlides((val*2 - 400).toInt());
                    },
                    hapticFeedbackType: HapticFeedbackType.selectionClick,
                  ),
                  ),
                  const SizedBox(height: 10),
                ],
           ),
          
        ],)
    );
  }
}
