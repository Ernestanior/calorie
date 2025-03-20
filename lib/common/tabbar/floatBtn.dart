import 'package:calorie/common/icon/index.dart';
import 'package:calorie/network/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
class FloatBtn extends StatefulWidget {
  const FloatBtn({super.key});

  @override
  State<FloatBtn> createState() => _FloatBtnState();
}

class _FloatBtnState extends State<FloatBtn> with SingleTickerProviderStateMixin {
    late AnimationController _animationController;
    late Animation<double> _animation;

    @override
    void initState() {
      super.initState();
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 1.0,
        upperBound: 1.2,
      )..repeat(reverse: true);

      _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_animationController);
    }

    @override
    void dispose() {
      _animationController.dispose();
      super.dispose();
    }

    void onCamera () async{
      final ImagePicker picker = ImagePicker();
      final XFile? photo =
          await picker.pickImage(source: ImageSource.camera);
      if (photo == null) {
        return;
      }
      final file = File(photo.path);
      List<int> imageBytes = await file.readAsBytes();
      String base64Image = base64Encode(imageBytes);
    }

    void onLibrary () async{
      final ImagePicker picker = ImagePicker();
      final XFile? image =
          await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }
      final file = File(image.path);
      List<int> imageBytes = await file.readAsBytes();
      // Convert image to base64
      String base64Image = base64Encode(imageBytes);
      var formData = FormData({'file': base64Image});
      dynamic imgUrl = await imgRender({'imgBase64':base64Image});

    }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
            scale: _animation,
            child: FloatingActionButton(
              shape:CircleBorder(),
              onPressed: () {
                // onLibrary();
                // onCamera();
                // Navigator.pushNamed(context, '/scan');
                Navigator.pushNamed(context, '/camera');
              },
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              splashColor:const Color.fromARGB(255, 0, 0, 0),
              child: 
                Icon(AliIcon.camera_fill, size: 30, color: const Color.fromARGB(255, 255, 255, 255)), 
            ));}
  }