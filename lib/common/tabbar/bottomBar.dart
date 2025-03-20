import 'package:calorie/common/icon/index.dart';
import 'package:calorie/page/home/index.dart';
import 'package:calorie/page/profile/index.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: (){
                  if (Controller.c.tab.value=='profile') {
                    Get.offAll(const Home());
                    setState(() {
                      Controller.c.tab('home');
                    });
                  }
                },
                child: Column(
                  children: [
                    Icon(AliIcon.home, size: 30, color: Controller.c.tab.value=='home'?Colors.black:const Color.fromARGB(255, 134, 134, 134)), 
                    Text('主页',style: TextStyle(fontSize: 11,color: Controller.c.tab.value=='home'?Colors.black:const Color.fromARGB(255, 134, 134, 134)),)
                  ],
                ),
              ),
              const SizedBox(),
              GestureDetector(
                onTap: (){
                  if (Controller.c.tab.value=='home') {
                    Get.offAll(const Profile());
                    setState(() {
                      Controller.c.tab('profile');
                    });
                  }

                },
                child: Column(
                children: [
                    Icon(AliIcon.mine, size: 30, color: Controller.c.tab.value=='profile'?Colors.black:const Color.fromARGB(255, 134, 134, 134)), 
                  Text('我',style: TextStyle(fontSize: 11,color: Controller.c.tab.value=='profile'?Colors.black:const Color.fromARGB(255, 134, 134, 134)),)
                ],
              ),
              ),
            ],
          ),
        );
    }
  }