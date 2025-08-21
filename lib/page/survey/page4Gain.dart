import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_slider/wheel_slider.dart';


class SurveyPage4Gain extends StatefulWidget {

  final int unitType;
  final double weight;
  final int slideIndex;
  final Function onChangeSlides;
  const SurveyPage4Gain({super.key, required this.unitType, required this.weight, required this.onChangeSlides, required this.slideIndex});
  @override
  State<SurveyPage4Gain> createState() => _SurveyPage4GainState();
}

class _SurveyPage4GainState extends State<SurveyPage4Gain> {
  @override
  Widget build(BuildContext context) {
    double currentWeight=widget.weight!=0 ?widget.weight: (widget.unitType == 1 ? 150:70);
    String unitType = widget.unitType == 1 ? 'lbs' : 'kg';
    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
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
                            fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: unitType=='kg',
                    child:WheelSlider(
                    interval: 0.5,
                    totalCount: 200,
                    initValue: widget.slideIndex * 0.5,
                    isInfinite: false,
                    enableAnimation: false,
                    onValueChanged: (val) {
                      print('gain $val');
                      widget.onChangeSlides((val*2).toInt());
                    },
                    hapticFeedbackType: HapticFeedbackType.selectionClick,
                  ), 
                  ),
                  Visibility(
                    visible: unitType=='lbs',
                    child:WheelSlider(
                    interval: 0.5,
                    totalCount: 400,
                    initValue: widget.slideIndex * 0.5 ,
                    isInfinite: false,
                    enableAnimation: false,
                    onValueChanged: (val) {
                      widget.onChangeSlides((val*2).toInt());
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
