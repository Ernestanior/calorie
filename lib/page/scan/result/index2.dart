import 'package:calorie/common/icon/index.dart';
import 'package:calorie/common/util/constants.dart';
import 'package:calorie/components/buttonX/index.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ScanResult extends StatefulWidget {
  const ScanResult({super.key});

  @override
  State<ScanResult> createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  final PanelController _panelController = PanelController();

  @override
  void initState() {
    super.initState();
    // 页面绘制完成后调用打开面板
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _panelController.open(); // 展开到最大高度
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // 背景图像
          Container(
            height: screenHeight,
            // padding:const EdgeInsets.only(top: 60),
            child: Image.network(
              Controller.c.scanResult['img'],
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          SlidingUpPanel(
            controller: _panelController, // 加上 controller
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            minHeight: 230, // 初始展开高度可调整
            maxHeight: screenHeight * 0.8,
            panelBuilder: (ScrollController sc) => _buildPanelContent(sc),
            body: const SizedBox(), // 可忽略
          ),
          
        ],
      ),
    );
  }

  Widget _buildPanelContent(ScrollController controller) {
    return Container(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMealHeader(),
              const SizedBox(height: 10),
              _buildNutritionStats(),
              const SizedBox(height: 30),
              _buildIngredients(),
              const SizedBox(height: 30),
              _buildNutrition(Controller.c.scanResult['total']['micronutrients']??{}),
              const SizedBox(height: 10),
              buildCompleteButton(context,'DONE'.tr,(){
                print(Controller.c.scanResult);
                Get.back();
              }),
              const SizedBox(height: 20),
            ],
          ),
        )
    );
  }

  Widget _buildMealHeader() {
    final meal = mealInfoMap[Controller.c.scanResult['mealType']];
    return Row(
      children: [
        Text("${Controller.c.scanResult['total']['dishName']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8,),
        GestureDetector(
          onTap: () => _showEditDishNameModal(context),
          child: const Icon(Icons.edit, size: 18, color: Color.fromARGB(255, 81, 81, 81)),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: meal?['color']??const Color.fromARGB(255, 255, 159, 14),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(meal?['label']??'DINNER'.tr, style: const TextStyle(color: Colors.white,fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildNutritionStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.local_fire_department, color: Colors.red),
            SizedBox(width: 6),
            Text("${Controller.c.scanResult['total']['calories']} kcal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _stat("CARBS".tr, Controller.c.scanResult['total']['carbs'], AliIcon.dinner4,Colors.blueAccent),
            _stat("PROTEIN".tr, Controller.c.scanResult['total']['protein'], AliIcon.meat2,Colors.redAccent),
            _stat("FATS".tr, Controller.c.scanResult['total']['fat'], AliIcon.fat,Colors.orangeAccent),
          ],
        ),
      ],
    );
  }

  static Widget _stat(String name, dynamic value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow:const [BoxShadow(
                  color: Color.fromARGB(31, 89, 89, 89),
                  blurRadius: 10,
                  spreadRadius: 1,
                )] 
      ),
      child: Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 250, 246, 246),
          radius: 24,
            child: Icon(icon, size: 24, color: iconColor),
        ),
        const SizedBox(height: 4),
        Text(name,style: const TextStyle(fontSize:12)),
        const SizedBox(height: 2),
        Text('${value}', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
    ) ;
  }

  Widget _buildIngredients() {
    List<dynamic> ingredients = Controller.c.scanResult['ingredients'];

    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("食材 (kcal)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Wrap(
            alignment: WrapAlignment.end,
            spacing: 16,
            runSpacing: 12,
            children: ingredients.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow:const [BoxShadow(
                            color: Color.fromARGB(31, 89, 89, 89),
                            blurRadius: 5,
                            spreadRadius: 1,
                          )] 
                ),
                child: Column(
                  children: [
                    Text("${item['name']}"),
                    const SizedBox(height: 5,),
                    Text("${item['calories']}",style: const TextStyle(fontSize: 12),),
                  ],
                ) 
              );
            }).toList(),
          ),
        ],
      );
  }

Widget _buildNutrition(Map<String, dynamic> nutritionData) {
  // 只保留 value 不为 0 且 key 存在于 nutritionLabelMap 的项
  final filteredItems = nutritionData.entries.where((e) {
    final key = e.key;
    final value = e.value;
    return value != 0 && nutritionLabelMap.containsKey(key);
  }).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("营养成分", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      Wrap(
        alignment: WrapAlignment.start,
        spacing: 16,
        runSpacing: 12,
        children: filteredItems.map((item) {
          String key = item.key;
          dynamic value = item.value;

          // 格式化数值
          String displayValue = value % 1 == 0 ? value.toInt().toString() : value.toString();

          // 获取 label 和单位（这里可以直接用！因为已经判断过 key 存在）
          String label = nutritionLabelMap[key]!["label"]!;
          String unit = nutritionLabelMap[key]!["unit"]!;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(31, 89, 89, 89),
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Column(
              children: [
                Text(label),
                const SizedBox(height: 5),
                Text("$displayValue $unit", style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        }).toList(),
      ),
    ],
  );
}
}

void _showEditDishNameModal(BuildContext context) {
  final TextEditingController _controller = TextEditingController(
    text: Controller.c.scanResult['detectionResultData']['total']['dishName'] ?? '',
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              
              onSubmitted: (value) {
                final newName = value.trim();
                if (newName.isNotEmpty) {
                  Controller.c.scanResult['detectionResultData']['total']['dishName'] = newName;
                }
                Navigator.pop(context); // 关闭 bottom sheet
              },
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 154, 154, 154))),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
