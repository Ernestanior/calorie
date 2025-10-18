import 'package:calorie/common/icon/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';

class VipDialog extends StatelessWidget {
  const VipDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromARGB(255, 255, 243, 226)!, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Image.asset('assets/image/vip.jpeg',
                      width: 126,),
            SizedBox(height: 16),
            Text(
              'UNLOCK_PREMIUM_TITLE'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'UNLOCK_PREMIUM_DESC'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown[700],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
               Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEAC794),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'START_NOW'.tr,
                    style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
