import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_picker/wheel_picker.dart';
import '../buttonX/index.dart';


class StepSheet extends StatefulWidget {
  const StepSheet({super.key});
  @override
  State<StepSheet> createState() => _StepSheetState();
}

class _StepSheetState extends State<StepSheet> {

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 15, height: 2,fontWeight: FontWeight.w600);

    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      height: 430,
      padding: const EdgeInsets.all(15),
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
          CarouselSlider(
            options: CarouselOptions(height: 400.0),
            items: [1,2,3,4,5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.amber
                    ),
                    child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                  );
                },
              );
            }).toList(),
          ),
          Text(
            'AUTHORIZE_APPLE_HEALTH'.tr,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20,),
          Text(
            'AUTHORIZE_APPLE_HEALTH_TIP_1'.tr,
            style: const TextStyle(
                fontSize: 14,
            ),
          ),
          buildCompleteButton(context,'CONFIRM'.tr,(){
            Get.back();
          })
        ],
      ),
    );
  }
}


