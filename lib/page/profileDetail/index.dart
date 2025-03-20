import 'package:calorie/common/icon/index.dart';
import 'package:calorie/components/actionSheets/age.dart';
import 'package:calorie/components/actionSheets/gender.dart';
import 'package:calorie/components/actionSheets/height.dart';
import 'package:calorie/components/buttonX/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  int height = 175;
  int age = 25;
  String gender = 'male';
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('PERSONAL_DETAIL'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
      ),
      backgroundColor:Colors.white,
      body: Expanded(
        child: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildOptionsList(),
            buildCompleteButton(context,'SAVE'.tr,(){
            Get.back();
          })
          ],
        ),
      )
      ) ,
    );
  }

  Widget _buildOptionsList() {
    return  Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 2,color: const Color.fromARGB(255, 238, 238, 238))
      ),
      child: Column(
      children:  [
        _OptionItem(title: 'HEIGHT'.tr,value: '$height '+'CM'.tr,function: () {
          Get.bottomSheet(HeightSheet(height:height,onChange:(value){
            setState(() {
              height=value;
            });
        }));
        },),
        _OptionItem(title: 'GENDER'.tr,value:gender=='male'?'MALE'.tr:'FEMALE'.tr,function: () {
          Get.bottomSheet(GenderSheet(gender:gender,onChange:(value){
          setState(() {
            gender=value;
          });
        }));
      },),
        _OptionItem(title: 'AGE'.tr,value:'$age ${'YEARS'.tr}',function: () {
        Get.bottomSheet(AgeSheet(age:age,onChange:(value){
          setState(() {
            age=value;
          });
        }));
      },),
      ],
    ));
  }

}


class _OptionItem extends StatelessWidget {
  final String title;
  final String value;
  final dynamic function;

  const _OptionItem({required this.title, required this.value, required this.function});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
      title: Expanded(child: 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        )
      ) ,
      trailing: const Icon(Icons.edit, color: Color.fromARGB(255, 0, 0, 0),size: 18,),
      onTap: function,
    );
  }
}
