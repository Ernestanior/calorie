import 'dart:io';

import 'package:calorie/common/util/constants.dart';
import 'package:calorie/store/store.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _selectedMeal = 1;
  bool _isCameraInitialized = false;

  bool _isPicking = false;
  @override
  void initState()  {
    super.initState();
_initCamera();
  }

  Future<void> _initCamera() async {
          _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(_cameras![0], ResolutionPreset.high,enableAudio: false,);

      await _cameraController!.initialize();
      await _cameraController!
          .lockCaptureOrientation(DeviceOrientation.portraitUp);
      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    }
  }

  Future<void> _takePicture() async {
    if (_isPicking) return;

    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile image = await _cameraController!.takePicture();
        final file = File(image.path);
        // List<int> imageBytes = await file.readAsBytes();
        // Convert image to base64
        // String base64Image = base64Encode(imageBytes);
        // var formData = FormData({'file': base64Image});
        Controller.c.image({'mealType': _selectedMeal, 'path': file.path});
        Controller.c.startAnalyzing();
        // Navigator.of(context).pushReplacementNamed('/scan');
        Navigator.of(context).pop();
        Controller.c.tabIndex(0);
      } catch (e) {
        print('Error picking image: $e');
      } finally {
        _isPicking = false;
      }
    }
  }

  Future<void> _pickImage() async {
    if (_isPicking) return;
    _isPicking = true;
    print('开始选择图片...');

    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker
          .pickImage(
        source: ImageSource.gallery,
      )
          .timeout(
        const Duration(seconds: 15), // ✅ 设置超时时间
        onTimeout: () {
          print('选图超时，可能是 GIF 卡住了');
          return null; // 返回 null，当作用户取消
        },
      );

      if (image == null) {
        print('用户取消选择');
        return;
      }

      // 判断文件扩展名
      final String extension = image.path.split('.').last.toLowerCase();
      if (extension == 'gif') {
        print('禁止选择 GIF 图片');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('GIF 格式暂不支持，请选择 JPG/PNG 图片')),
          );
        }
        return;
      }

      print('选中图片: ${image.path}');
      final file = File(image.path);

      Controller.c.image({
        'mealType': _selectedMeal,
        'path': file.path,
      });

      Controller.c.startAnalyzing();

      if (mounted) {
        Navigator.of(context).pop();
        Controller.c.tabIndex(0);
      }
    } on PlatformException catch (e) {
      print('PlatformException: $e');
    } catch (e) {
      print('选择图片出错: $e');
    } finally {
      _isPicking = false;
      print('done');
    }
  }

  Widget _buildMealSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: mealOptions().map((meal) {
        return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMeal = meal['value'];
              });
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(.5),
                        border: Border.all(
                            color: meal['value'] == _selectedMeal
                                ? meal['color']
                                : const Color.fromARGB(0, 255, 237, 237))),
                    child: Row(
                      children: [
                        Icon(meal['icon'],
                            color: meal['value'] == _selectedMeal
                                ? meal['color']
                                : Colors.white,
                            size: 16),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          meal['label'],
                          style: TextStyle(
                              color: meal['value'] == _selectedMeal
                                  ? meal['color']
                                  : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ))
                // ChoiceChip(
                //   label: Text(meal),
                //   selected: isSelected,
                //   onSelected: (selected) {
                //     setState(() => _selectedMeal = meal);
                //   },
                //   labelStyle: TextStyle(color: Colors.white ),
                // backgroundColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(.2),
                // ),
                ));
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraInitialized
          ? Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      child: CameraPreview(_cameraController!),
                    ),
                    Positioned(
                      top: 60,
                      left: 20,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      top: 180,
                      left: 50,
                      right: 50,
                      child: Column(
                        children: [
                          Text("ENSURE_FOOD_IS_WITHIN_THE_GUIDE_BOX".tr,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 10),
                          // 绘制辅助框
                          Center(
                            child: CustomPaint(
                              size: const Size(250, 250), // 控制框的大小
                              painter: OverlayPainter(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 0,
                      right: 0,
                      child: _buildMealSelection(),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.photo,
                              color: Colors.white, size: 40),
                          onPressed: _pickImage,
                        ),
                        GestureDetector(
                          onTap: _takePicture,
                          child: Container(
                            width: 70,
                            height: 70,
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1.5, color: Colors.black),
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 55,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}

// 画镂空的辅助框
class OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    double cornerLength = 20;

    // 画四个角
    Path path = Path();

    // 左上角
    path.moveTo(0, cornerLength);
    path.lineTo(0, 0);
    path.lineTo(cornerLength, 0);

    // 右上角
    path.moveTo(size.width - cornerLength, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, cornerLength);

    // 右下角
    path.moveTo(size.width, size.height - cornerLength);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - cornerLength, size.height);

    // 左下角
    path.moveTo(cornerLength, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
