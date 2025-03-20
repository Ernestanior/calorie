// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:get/get.dart';


class Weight extends StatefulWidget {
  const Weight({super.key});
  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  RulerPickerController? _rulerPickerController;
  RulerPickerController? _rulerPickerController2;

  num currentWeight = 40;
  num targetWeight = 60;

  List<RulerRange> ranges = const [
    RulerRange(begin: 0, end: 100, scale: 0.1),
    RulerRange(begin: 100, end: 300, scale: 1),
  ];

  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: currentWeight);
    _rulerPickerController2 = RulerPickerController(value: targetWeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('UPDATE_WEIGHT'.tr,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
      ),
      body: 
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: 
            Column(
              children: [
                const SizedBox(height: 50,),
                Text('CURRENT_WEIGHT'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                const SizedBox(height: 5,),
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
                        const SizedBox(width: 5,),
                        const Text(
                          'kg',
                          
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    RulerPicker(
                      controller: _rulerPickerController!,
                      onBuildRulerScaleText: (index, value) {
                        return value.toInt().toString();
                      },
                      ranges: ranges,
                      rulerScaleTextStyle: TextStyle(color: Colors.black),
                      scaleLineStyleList: const [
                        ScaleLineStyle(
                            color: Color.fromARGB(255, 0, 0, 0), width: 1.5, height: 30, scale: 0),
                        ScaleLineStyle(
                            color: Color.fromARGB(255, 0, 0, 0), width: 1, height: 25, scale: 5),
                        ScaleLineStyle(
                            color: Color.fromARGB(255, 0, 0, 0), width: 1, height: 15, scale: -1)
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
                    const SizedBox(height: 10),

                  ],
                ),
                const SizedBox(height: 100,),
                Text('TARGET_WEIGHT'.tr,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                const SizedBox(height: 5,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Text(
                          targetWeight.toStringAsFixed(1),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        const SizedBox(width: 5,),
                        const Text(
                          'kg',
                          
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    RulerPicker(
                      controller: _rulerPickerController2!,
                      onBuildRulerScaleText: (index, value) {
                        return value.toInt().toString();
                      },
                      ranges: ranges,
                      rulerScaleTextStyle: TextStyle(color: Colors.black),
                      scaleLineStyleList: const [
                        ScaleLineStyle(
                            color: Color.fromARGB(255, 0, 0, 0), width: 1.5, height: 30, scale: 0),
                        ScaleLineStyle(
                            color: Color.fromARGB(255, 0, 0, 0), width: 1, height: 25, scale: 5),
                        ScaleLineStyle(
                            color: Color.fromARGB(255, 0, 0, 0), width: 1, height: 15, scale: -1)
                      ],

                      onValueChanged: (value) {
                        setState(() {
                          targetWeight = value;
                        });
                      },
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      rulerMarginTop: 8,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),

              ],
            )
          ),
          buildCompleteButton()
        ],
      )
    );
  }
}

/// **完成按钮**
  Widget buildCompleteButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          
        },
        child: Text("SAVE".tr, style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold)),
      ),
    );
  }