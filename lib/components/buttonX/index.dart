import 'package:flutter/material.dart';

/// **完成按钮**
  Widget buildCompleteButton(BuildContext context,String text, dynamic onSubmit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          minimumSize: const Size(double.infinity, 48),
        ),
        onPressed: onSubmit,
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold)),
      ),
    );
  }