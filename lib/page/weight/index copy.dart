// import 'dart:html';
import 'package:calorie/components/buttonX/index.dart';
import 'package:calorie/network/api.dart';
import 'package:calorie/store/store.dart';
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


  List<RulerRange> ranges = const [
    RulerRange(begin: 0, end: 100, scale: 0.1),
    RulerRange(begin: 100, end: 300, scale: 1),
  ];
  
  num currentWeight = Controller.c.user['currentWeight'];

  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: currentWeight);
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
                Text('CURRENT_WEIGHT'.tr,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
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
                        Text(
                          Controller.c.user['unitType']==0?'kg':'lbs',
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
              ],
            )
          ),
          buildCompleteButton(context,"SAVE".tr,() async{
            await userModify({
              'currentWeight':double.parse(currentWeight.toStringAsFixed(1)),
            });
            final res = await getUserDetail();
            Controller.c.user(res);
            Navigator.pop(context);
          }),
        
        ],
      )
    );
  }
}

