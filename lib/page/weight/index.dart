// import 'dart:html';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:calorie/page/weight/weightChart.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final GlobalKey chartKey = GlobalKey(); // 顶部添加

class Weight extends StatefulWidget {
  const Weight({super.key});
  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {

  num currentWeight = Controller.c.user['currentWeight'];
  num targetWeight = Controller.c.user['targetWeight'];
  String unitType = Controller.c.user['unitType'] == 0 ? "kg" : "lbs";

  List<RulerRange> ranges = const [
    RulerRange(begin: 0, end: 100, scale: 0.1),
    RulerRange(begin: 100, end: 300, scale: 1),
  ];

  List recordList = [
    {'date': 'Jun 1', 'weight': 79.1},
    {'date': 'Jun 5', 'weight': 75.1},
    {'date': 'Jun 11', 'weight': 77.4},
    {'date': 'Jun 12', 'weight': 75.3},
    {'date': 'Jun 13', 'weight': 74.1},
    {'date': 'Jun 15', 'weight': 76.1},
    {'date': 'Jun 20', 'weight': 72.1},
    {'date': 'Jun 25', 'weight': 75.1},
    {'date': 'Jun 29', 'weight': 75.1},
    {'date': 'Jul 1', 'weight': 74.3},
    {'date': 'Jul 3', 'weight': 76},
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _captureAndSharePng() async {
    try {
      // 请求权限
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        Get.snackbar('权限错误', '请授予存储权限');
        return;
      }

      final boundary = chartKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        Get.snackbar('错误', '找不到图表区域');
        return;
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // 保存到临时文件用于分享
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/chart_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      // ✅ 保存到相册
      // final result = await ImageGallerySaver.saveImage(
      //   Uint8List.fromList(pngBytes),
      //   quality: 100,
      //   name: "WeightChart_${DateTime.now().millisecondsSinceEpoch}",
      // );

      // if (result['isSuccess'] == true) {
      //   Get.snackbar('保存成功', '图表已保存到相册');
      // } else {
      //   Get.snackbar('保存失败', '请检查权限或重试');
      // }

      // ✅ 分享图片
      await Share.shareXFiles([XFile(filePath)], text: '这是我的体重变化图表');

    } catch (e) {
      print('Error sharing chart: $e');
      Get.snackbar('分享失败', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'UPDATE_WEIGHT'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: '分享图表',
            onPressed: _captureAndSharePng,
          ),
        ],
      ),
        body: RepaintBoundary(
            key: chartKey,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 247, 246, 255),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HealthInfoCard(
                          title: "CURRENT_WEIGHT".tr,
                          value: Controller.c.user['currentWeight'],
                          unit: unitType),
                      HealthInfoCard(
                          title: "INIT_WEIGHT".tr,
                          value: Controller.c.user['currentWeight'],
                          unit: unitType),
                      HealthInfoCard(
                          title: "TARGET_WEIGHT".tr,
                          value: Controller.c.user['targetWeight'],
                          unit: unitType),
                    ],
                  ),
                  weightRecord(),
                  SizedBox(height: 5,),
                  WeightChart(unitType:unitType),
                ],
              ),
            )));
  }

  Widget weightRecord() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                children: recordList
                    .map(
                      (item) => Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromARGB(31, 255, 151, 151),
                                blurRadius: 5,
                                spreadRadius: 2),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(item['date'],
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 116, 116, 116))),
                            const SizedBox(height: 8),
                            Text.rich(
                              TextSpan(
                                text: '${item['weight']} ',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                      text: unitType,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: Color.fromARGB(
                                              255, 113, 113, 113),
                                          fontWeight: FontWeight.normal))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            )),
            SizedBox(height: 10,),
        Center(
          child: Container(
              width: 180,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    'RECORD_WEIGHT'.tr,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
        )
      ]),
    );
  }
}

/// 健康数值卡片
class HealthInfoCard extends StatelessWidget {
  final String title, unit;
  final dynamic value;
  const HealthInfoCard(
      {super.key,
      required this.title,
      required this.value,
      required this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(31, 232, 232, 232),
                blurRadius: 5,
                spreadRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 12, color: Color.fromARGB(255, 116, 116, 116))),
            const SizedBox(height: 6),
            Text.rich(
              TextSpan(
                text: '$value',
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: ' $unit',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 113, 113, 113),
                          fontWeight: FontWeight.normal))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}