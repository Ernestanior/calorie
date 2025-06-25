import 'package:calorie/common/circlePainter/index.dart';
import 'package:calorie/common/circlePainter/new.dart';
import 'package:calorie/common/icon/index.dart';
import 'package:calorie/network/api.dart';
import 'package:calorie/page/weight/index.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color.fromARGB(255, 201, 225, 255), Colors.white, Color.fromARGB(255, 241, 252, 255)],
          ),
        ),
        child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            _buildHeader(),
            const SizedBox(height: 15),
            _buildCurrentWeight(),
            _buildBMICircle(),
            _buildOptionsList(),
          ],
        ),
        ),
      ),
    );
  }

    Widget _buildHeader() {
    return Text(
        'MINE'.tr,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      );
  }

  // Widget _buildUserInfo() {
  //   return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _UserInfoRow(label: 'AGE'.tr, value: '1'),
  //         _UserInfoRow(label: 'HEIGHT'.tr, value: '167 cm'),
  //       ],
  //   );
  // }
  List weightList=[{'title':'CURRENT'.tr,'weight':67,'icon':AliIcon.fitness},
  {'title':'TARGET'.tr,'weight':64,'icon':AliIcon.fitness}];

  Widget _buildCurrentWeight() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: const Color.fromARGB(66, 175, 175, 175), blurRadius: 10, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "MY_WEIGHT".tr,
            style:const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
            
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:  [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(255, 75, 75, 75),width: 2),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Container(  
                    padding: const EdgeInsets.all(6),
                     decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color.fromARGB(255, 75, 75, 75), Color.fromARGB(255, 75, 75, 75),Color.fromARGB(255, 195, 195, 195)],
                    )),
                    child: const Icon(AliIcon.fitness, color: Colors.white, size: 22) ,
                    ),
                  ),
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CURRENT'.tr, style: const TextStyle(fontSize: 12)),
                      Row(
                          children: [
                            Obx(()=>Text('${Controller.c.user['currentWeight'].round()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                            const SizedBox(width: 5),              
                            Text(Controller.c.user['unitType']==0?'kg':'lbs', style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 105, 105, 105))),
                          ],
                        )
                      ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(1.5),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromARGB(255, 75, 75, 75),width: 2),
                      borderRadius: BorderRadius.circular(30)
                    ),
                  child:Container(  
                    padding: const EdgeInsets.all(6),
                     decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color.fromARGB(255, 75, 75, 75),Color.fromARGB(255, 75, 75, 75),Color.fromARGB(255, 255, 226, 226)],
                    )),
                    child: const Icon(AliIcon.flag2, color: Colors.white, size: 22) ,
                  ),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TARGET'.tr, style: const TextStyle(fontSize: 12)),
                      Row(
                        children: [
                          Obx(()=>Text('${Controller.c.user['targetWeight'].round()}', style: const TextStyle(fontSize:18, fontWeight: FontWeight.bold))),
                          const SizedBox(width: 5),              
                          Text(Controller.c.user['unitType']==0?'kg':'lbs', style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 133, 133, 133))),
                        ],
                      )
                    ],
                  )
                ]),
             
              ],
            ),
          const SizedBox(height: 22),
          GestureDetector(
            onTap: () async{ 
              Navigator.pushNamed(context, '/weight');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text('UPDATE_YOUR_WEIGHT'.tr,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ),
          )
        ],
      ),
    );
  }

Widget _buildBMICircle() {
  return  Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(31, 81, 81, 81),
                    blurRadius: 10,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Obx(()=>BMICard(
                bmi: Controller.c.user['unitType']==0?
                double.parse((
                  Controller.c.user['currentWeight']/(Controller.c.user['height'] * Controller.c.user['height']/10000)).toStringAsFixed(2))
                :double.parse((Controller.c.user['currentWeight']/(Controller.c.user['height']* Controller.c.user['height'])*703).toStringAsFixed(2)))));
  }

  Widget _buildOptionsList() {
    return  Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color.fromARGB(66, 175, 175, 175), blurRadius: 10, spreadRadius: 2)],
      ),
      child:Column(
      children:  [
        _OptionItem(title: 'PERSONAL_DETAIL'.tr,icon: AliIcon.setting1,url:'/profileDetail'),
        _OptionItem(title: 'ADJUST_CALORIE_GOAL'.tr,icon: AliIcon.edit2,url:"/survey"),
        _OptionItem(title: 'CONTACT_US'.tr,icon: AliIcon.email,url:'/contactUs'),
        _OptionItem(title: 'SETTING'.tr,icon: AliIcon.setting,url:'/setting'),
      ],
    ));
  }

}

class _UserInfoRow extends StatelessWidget {
  final String label;
  final String value;
  
  const _UserInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final String title;
  final String url;
  final IconData icon;

  final String? subtitle;

  const _OptionItem({required this.title,required this.icon,required this.url, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
      title: 
      Row(children: [
      Icon(icon,size: 18,),
      const SizedBox(width: 15,),
      Text(title, style: const TextStyle(fontSize: 15)),
      ],) ,
      subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(color: Colors.grey)) : null,
      trailing: const Icon(Icons.chevron_right, color: Color.fromARGB(255, 214, 214, 214)),
      onTap: () { 
        Navigator.pushNamed(context, url);
      },
    );
  }
}
