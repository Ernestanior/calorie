import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_picker/wheel_picker.dart';
import '../buttonX/index.dart';

class StepsSheet extends StatefulWidget {
  final int steps;
  final Function onChange;
  const StepsSheet({super.key, required this.steps, required this.onChange});
  @override
  State<StepsSheet> createState() => _StepsSheetState();
}

class _StepsSheetState extends State<StepsSheet> {
  late int initSteps = widget.steps;

  static const textStyle =
      TextStyle(fontSize: 15, height: 2, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    var stepWheel = WheelPickerController(
        itemCount: 100, initialIndex: (initSteps / 500).toInt());

    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      height: 410,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 193, 193, 193),
                borderRadius: BorderRadius.circular(10)),
            width: 40,
            height: 5,
          ),
          const SizedBox(
            height: 35,
          ),
          Text(
            'TARGET_STEPS'.tr,
            style: const TextStyle(
                color: Color.fromARGB(255, 149, 149, 149),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                child: SizedBox(
                    height: 200,
                    width: 170,
                    child: WheelPicker(
                      looping: false,
                      builder: (context, index) =>
                          Text("${(index + 1) * 500}", style: textStyle),
                      controller: stepWheel,
                      selectedIndexColor: Colors.black,
                      onIndexChanged: (index, interactionType) {
                        setState(() {
                          initSteps = index * 500;
                        });
                      },
                      style: WheelPickerStyle(
                        itemExtent: textStyle.fontSize! *
                            textStyle.height!, // Text height
                        squeeze: 1.1,
                        diameterRatio: 1,
                        surroundingOpacity: 0.15,
                        magnification: 1.2,
                      ),
                    )),
              ),
            ],
          ),
          buildCompleteButton(context, 'CONFIRM'.tr, () {
            widget.onChange(initSteps + 500);
            Get.back();
          })
        ],
      ),
    );
  }
}
