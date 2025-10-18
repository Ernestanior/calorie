import 'package:calorie/common/icon/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class DiscountDialog extends StatelessWidget {
  const DiscountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 25),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Image.asset('assets/image/discount.jpeg',
                      width: 136,),
            SizedBox(height: 16),
            Text(
              'CONGRATS'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'UNLOCKED_LIMITED_TIME_DISCOUNT'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown[700],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
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
                    'CLAIM_NOW'.tr,
                    style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.bold),
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
