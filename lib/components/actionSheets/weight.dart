import 'package:calorie/network/api.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:get/get.dart';
import 'package:wheel_slider/wheel_slider.dart';
import '../buttonX/index.dart';

class WeightSheet extends StatefulWidget {
  final double weight;
  const WeightSheet({super.key, required this.weight});
  @override
  State<WeightSheet> createState() => _WeightSheetState();
}

class _WeightSheetState extends State<WeightSheet> {
  late double currentWeight = widget.weight.toDouble();

  List<RulerRange> ranges = const [
    RulerRange(begin: 0, end: 100, scale: 0.1),
    RulerRange(begin: 100, end: 300, scale: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      height: 280,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
                'RECORD_WEIGHT'.tr,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 5,
              ),
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
                            fontWeight: FontWeight.w600,
                            fontSize: 25),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        Controller.c.user['unitType'] == 0 ? 'kg' : 'lbs',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  WheelSlider(
                    interval: 0.5,
                    totalCount: 1100,
                    initValue: currentWeight*5,
                    isInfinite: false,
                    enableAnimation: false,
                    onValueChanged: (val) {
                      setState(() {
                        currentWeight = val*0.2;
                      });
                    },
                    hapticFeedbackType: HapticFeedbackType.selectionClick,
                  ),
                  const SizedBox(height: 10),
                ],
           ),
          buildCompleteButton(context,"SAVE".tr,() async{
            print(double.parse(currentWeight.toStringAsFixed(2)));
            await weightCreate(double.parse(currentWeight.toStringAsFixed(2)));
            final res = await getUserDetail();
            Controller.c.user(res);
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }
}
