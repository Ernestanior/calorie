import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenderSheet extends StatefulWidget {
  final int gender;
  final Function onChange;
  const GenderSheet({super.key,required this.gender,required this.onChange});
  @override
  State<GenderSheet> createState() => _GenderSheetState();
}

class _GenderSheetState extends State<GenderSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      height: 260,
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              backgroundColor: widget.gender==1?Colors.black:const Color.fromARGB(255, 244, 243, 243),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              minimumSize: const Size(double.infinity, 50),
              shadowColor: const Color.fromRGBO(0, 255, 255, 255),
            ),
            onPressed: () {
              widget.onChange(1);
              Get.back();
            },
            child: Text("MALE".tr, style: TextStyle(color: widget.gender==1?Colors.white:Colors.black, fontSize: 18,fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              backgroundColor: widget.gender==2?Colors.black:const Color.fromARGB(255, 244, 243, 243),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              minimumSize: const Size(double.infinity, 50),
              shadowColor: const Color.fromRGBO(0, 255, 255, 255),
            ),
            onPressed: () {
              widget.onChange(2);
              Get.back();
            },
            child: Text("FEMALE".tr, style: TextStyle(color: widget.gender==2?Colors.white:Colors.black, fontSize: 18,fontWeight: FontWeight.bold)),
          ),  

        ],
      ),
    );
  }
}
