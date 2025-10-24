import 'dart:math';

import 'package:calorie/common/icon/index.dart';
import 'package:calorie/common/util/constants.dart';
import 'package:calorie/common/util/utils.dart';
import 'package:calorie/components/actionSheets/shareFood.dart';
import 'package:calorie/components/dialog/nutrition.dart';
// import 'package:calorie/components/buttonX/index.dart';
import 'package:calorie/network/api.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

class FoodDetail extends StatefulWidget {
  const FoodDetail({super.key});

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  // final PanelController _panelController = PanelController();
  int _selectedMeal = Controller.c.foodDetail['mealType'];
  String _dishName =
      Controller.c.foodDetail['detectionResultData']['total']['dishName'];

  double? _imageHeight;
  double? _imageWidth;

  void _loadImageSize() {
    final img = Image.network(Controller.c.foodDetail['sourceImg']).image;
    img.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        setState(() {
          _imageWidth = info.image.width.toDouble();
          _imageHeight = info.image.height.toDouble();
        });
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadImageSize();
    // 页面绘制完成后调用打开面板
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _panelController.open(); // 展开到最大高度
    // });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // 计算背景图显示高度
    double displayHeight;
    if (_imageWidth != null && _imageHeight != null) {
      final aspectRatio = _imageWidth! / _imageHeight!;
      if (aspectRatio < 1) {
        // 竖图：宽度撑满，高度自适应
        displayHeight = screenWidth / aspectRatio;
      } else {
        // 横图：固定高度 400
        displayHeight = 400;
      }
    } else {
      displayHeight = screenHeight * 0.6; // 默认占 60%
    }
    Widget _buildMealHeader() {
      final meal = mealInfoMap[_selectedMeal];
      return Row(
        children: [
          SizedBox(
            width: 250,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        _dishName.isEmpty ? 'Unknow Food' : _dishName, // 你的多行文本
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle, // 图标对齐到文字中间或底部
                    child: GestureDetector(
                      onTap: () => _showEditDishNameModal(context),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 4), // 图标和文字之间加点间距
                        child: Icon(
                          Icons.edit,
                          size: 18,
                          color: Color.fromARGB(255, 81, 81, 81),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showEditMealTypeModal(context),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      meal?['color'] ?? const Color.fromARGB(255, 255, 159, 14),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Text(meal?['label'] ?? 'DINNER'.tr,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(Icons.edit,
                        size: 12, color: Color.fromARGB(255, 255, 255, 255))
                  ],
                )),
          ),
        ],
      );
    }

    Widget _buildPanelContent(ScrollController controller) {
      return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
          padding: const EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            controller: controller,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMealHeader(),
                const SizedBox(
                  height: 5,
                ),
                Text(formatDate(Controller.c.foodDetail['createDate']),
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),

                const SizedBox(height: 20),
                _buildNutritionStats(),
                const SizedBox(height: 30),
                _buildIngredients(),
                const SizedBox(height: 30),
                _buildNutrition(Controller.c.foodDetail['detectionResultData']
                        ['total']['micronutrients'] ??
                    {}),
                const SizedBox(height: 15),
                // buildCompleteButton(context,'SAVE'.tr,()async {
                //   final res = await detectionModify(Controller.c.foodDetail['id'],{'dishName':_dishName,'mealType':_selectedMeal});
                //   Get.back();
                // }),
                // const SizedBox(height: 15),
              ],
            ),
          ));
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Image.network(
                Controller.c.foodDetail['sourceImg'],
                width: double.infinity,
                height: displayHeight,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
              Positioned(
                top: 68,
                left: 20,
                child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: Color.fromARGB(150, 241, 241, 241),
                      child: Icon(
                        AliIcon.back2,
                        color: Colors.white,
                        size: 30,
                      ),
                    )),
              ),
              Positioned(
                top: 68,
                right: 20,
                child: GestureDetector(
                    onTap: () => Get.bottomSheet(ShareFoodSheet(),
                        isScrollControlled: true),
                    child: const CircleAvatar(
                      backgroundColor: Color.fromARGB(150, 241, 241, 241),
                      child: Icon(
                        AliIcon.share,
                        color: Colors.white,
                        size: 27,
                      ),
                    )),
              ),
              // SlidingUpPanel(
              //   controller: _panelController, // 加上 controller
              //   borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              //   minHeight: 230, // 初始展开高度可调整
              //   maxHeight: screenHeight * 0.8,
              //   panelBuilder: (ScrollController sc) => _buildPanelContent(sc),
              //   body: const SizedBox(), // 可忽略
              // ),
              DraggableScrollableSheet(
                initialChildSize: 0.53,
                minChildSize: max(
                    double.parse(((screenHeight - displayHeight) / screenHeight)
                        .toStringAsFixed(2)),
                    0.1),
                maxChildSize: 0.85,
                builder: (context, controller) {
                  return _buildPanelContent(controller);
                },
              )
            ],
          ),
        ));
  }

  Widget _buildNutritionStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        //     const Icon(Icons.local_fire_department, color: Colors.red),
        //     const SizedBox(width: 6),
        //     Text(
        //         "${Controller.c.foodDetail['detectionResultData']['total']['calories']} ${'KCAL'.tr}",
        //         style:
        //             const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        //   ],
        // ),
        // const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _stat(
                "CALORIE".tr,
                Controller.c.foodDetail['detectionResultData']['total']
                    ['calories'],
                Icons.local_fire_department,
                const Color.fromARGB(255, 255, 91, 21),
                'KCAL'.tr),
            _stat(
                "CARBS".tr,
                Controller.c.foodDetail['detectionResultData']['total']
                    ['carbs'],
                AliIcon.dinner4,
                Colors.blueAccent,
                'G'.tr),
            _stat(
                "FATS".tr,
                Controller.c.foodDetail['detectionResultData']['total']['fat'],
                AliIcon.meat2,
                Colors.redAccent,
                'G'.tr),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _stat(
                "PROTEIN".tr,
                Controller.c.foodDetail['detectionResultData']['total']
                    ['protein'],
                AliIcon.fat,
                Colors.orangeAccent,
                'G'.tr),
            _stat(
                "SUGAR".tr,
                Controller.c.foodDetail['detectionResultData']['total']
                    ['sugar'],
                AliIcon.sugar2,
                const Color.fromARGB(255, 64, 242, 255),
                'G'.tr),
            _stat(
                "FIBER".tr,
                Controller.c.foodDetail['detectionResultData']['total']
                    ['fiber'],
                AliIcon.fiber,
                const Color.fromARGB(255, 64, 255, 83),
                'G'.tr),
          ],
        ),
      ],
    );
  }

  static Widget _stat(
      String name, dynamic value, IconData icon, Color iconColor, String unit) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: 110,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(31, 89, 89, 89),
              blurRadius: 10,
              spreadRadius: 1,
            )
          ]),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 250, 246, 246),
            radius: 24,
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${value}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(' $unit',
                  style: TextStyle(
                      fontSize: 12, color: Color.fromARGB(255, 90, 90, 90))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildIngredients() {
    List<dynamic> ingredients =
        Controller.c.foodDetail['detectionResultData']['ingredients'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("FOOD_KCAL".tr,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 16,
          runSpacing: 12,
          children: ingredients.map((item) {
            return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(31, 89, 89, 89),
                        blurRadius: 5,
                        spreadRadius: 1,
                      )
                    ]),
                child: Column(
                  children: [
                    Text("${item['name'].isEmpty ? 'unknow' : item['name']}"),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${item['calories']}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNutrition(Map<String, dynamic> nutritionData) {
    // 只保留 value 不为 0 且 key 存在于 nutritionLabelMap 的项
    List filteredItems = nutritionData.entries.where((e) {
      final key = e.key;
      final value = e.value;
      return value != 0 && nutritionLabelMap().containsKey(key);
    }).toList();
    return filteredItems.isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("NUTRITIONAL_VALUE".tr,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              GridView.count(
                shrinkWrap: true, // 重要！让 GridView 适应内容高度（不滚动）
                physics: const NeverScrollableScrollPhysics(), // 禁止内部滚动，避免和外层冲突
                padding: const EdgeInsets.only(top: 22),
                crossAxisCount: 3, // 每行 3 个
                crossAxisSpacing: 16, // 横向间距
                mainAxisSpacing: 12, // 纵向间距
                childAspectRatio: 1.2 / 0.8, // 控制宽高比 1:1（方形），你可以改成 1.2 / 0.8 等
                children: filteredItems.map((item) {
                  String key = item.key;
                  dynamic value = item.value;
                  String displayValue = value % 1 == 0
                      ? value.toInt().toString()
                      : value.toString();

                  String label = nutritionLabelMap()[key]!["label"]!;
                  String unit = nutritionLabelMap()[key]!["unit"]!;

                  return GestureDetector(
                      onTap: () => showNutritionInfoDialog(context, key),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 17),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(label, style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 5),
                            Text("$displayValue $unit",
                                style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ));
                }).toList(),
              )
            ],
          );
  }

  void _showEditMealTypeModal(BuildContext context) {
    // final TextEditingController controller = TextEditingController(
    //   text: _dishName,
    // );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true, // 不滚动，内容多少就显示多少
              physics: const NeverScrollableScrollPhysics(), // 禁止滚动
              childAspectRatio:
                  (MediaQuery.of(context).size.width / 2 - 24) / 50, // 控制每项宽高比
              children: mealOptions().map((meal) {
                return GestureDetector(
                    onTap: () async {
                      setState(() {
                        _selectedMeal = meal['value'];
                      });
                      Navigator.pop(context);
                      await detectionModify(Controller.c.foodDetail['id'],
                          {'mealType': _selectedMeal});
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: meal['value'] == _selectedMeal
                                ? meal['color']
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: meal['color'])),
                        child: Row(
                          children: [
                            Icon(meal['icon'],
                                color: meal['value'] == _selectedMeal
                                    ? Colors.white
                                    : meal['color']),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              meal['label'],
                              style: TextStyle(
                                  color: meal['value'] == _selectedMeal
                                      ? Colors.white
                                      : meal['color'],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        )));
              }).toList(),
            ));
      },
    );
  }

  void _showEditDishNameModal(BuildContext context) {
    final TextEditingController _controller = TextEditingController(
      text: _dishName,
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
                maxLength: 45,
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) async {
                  final newName = value.trim();
                  if (newName.isNotEmpty) {
                    _dishName = newName;
                  }

                  Navigator.pop(context); // 关闭 bottom sheet
                  await detectionModify(
                      Controller.c.foodDetail['id'], {'dishName': newName});
                },
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 154, 154, 154))),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
