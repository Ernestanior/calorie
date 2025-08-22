import 'package:calorie/common/icon/index.dart';
import 'package:calorie/common/util/constants.dart';
import 'package:calorie/network/api.dart';
import 'package:calorie/page/recipe/detail/nutrition_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mealData.dart';

class RecipeDetail extends StatefulWidget {
  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  int selectedDay = 1;
  double _titleOpacity = 0.0;
  final recipeSet = Get.arguments;
    Map recipes = {};

  @override
  void initState() {
    super.initState();
    fetchData(recipeSet['id'],1);
  print(mealInfoMap);

  }

  Future<void> fetchData(int id,int day) async {
    try {
      final res = await recipePage(id,day);
      print(MealDataHelper.groupMealsByType(res['content']));
      if (!mounted) return;
      if (res.isNotEmpty) {
        setState(() {
          recipes =MealDataHelper.groupMealsByType(res['content']) ;
        });
      }
    } catch (e) {
      print('$e error');
    }
  }

  // double calculateOpacity(double shrinkOffset, double expandedHeight) {
  //   double opacity = shrinkOffset / (expandedHeight - kToolbarHeight);
  //   return opacity.clamp(0.0, 1.0);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // 顶部 AppBar
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              expandedHeight: 200,
              backgroundColor: Colors.white,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final double statusBarHeight = MediaQuery.of(context).padding.top;
                  final double expanded = 200 + statusBarHeight;
                  final double collapsed = kToolbarHeight + statusBarHeight;

                  double percent = ((constraints.maxHeight - collapsed) / (expanded - collapsed)).clamp(0.0, 1.0);
                  _titleOpacity = 1 - percent;

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://i.postimg.cc/ZntHyhVK/food.jpg',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        color: Color.lerp(const Color.fromARGB(148, 0, 0, 0), Colors.white, _titleOpacity),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 10,
                        left: 20,
                        right: 20,
                        child: Row(
                          children: [
                            _buildBackButton(),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Opacity(
                                  opacity: _titleOpacity,
                                  child: Text(
                                    recipeSet['name'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Opacity(
                          opacity: 1 - _titleOpacity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(recipeSet['name'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 15),
                              _buildPlanInfo(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // 吸顶 Day Selector
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverHeaderDelegate(
                minHeight: 56,
                maxHeight: 56,
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  child: _buildDaySelector(),
                ),
              ),
            ),
          ];
        },
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 15),
          children: [
            if (recipes[1] != null) ...[
                _buildMealCard(1),
                const SizedBox(height: 15),
              ],
              if (recipes[2] != null) ...[
                _buildMealCard(2),
                const SizedBox(height: 15),
              ],
              if (recipes[3] != null) ...[
                _buildMealCard(3),
              ],
            const NutritionPieChart(
              calories: 1356,
              carb: 148.0,
              protein: 96.0,
              fat: 58.0,
            ),
            const SizedBox(height: 20),
            _buildSetPlanButton(),
            const SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(AliIcon.back2, color: Colors.black, size: 26),
      ),
    );
  }

  Widget _buildPlanInfo() {
    List<Map<String, String>> infos = [
      {'title': 'PLAN_DURATION'.tr, 'value': '${recipeSet['day']}', 'unit': 'DAY'.tr},
      {'title': '${recipeSet['type']}', 'value': recipeSet['weight'], 'unit': 'KG'.tr},
      {'title': 'USERS'.tr, 'value': '${recipeSet['hot']}', 'unit': 'HOT_UNIT'.tr},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(infos.length * 2 - 1, (i) {
        if (i.isEven) {
          int infoIndex = i ~/ 2;
          var info = infos[infoIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(info['title']!,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text.rich(
                TextSpan(
                  text: info['value'],
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  children: [
                    TextSpan(
                        text: info['unit']!,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.normal))
                  ],
                ),
              ),
            ],
          );
        } else {
          return Container(
            height: 40,
            width: 0.5,
            color: Colors.white70,
            margin: const EdgeInsets.symmetric(horizontal: 15),
          );
        }
      }),
    );
  }

  Widget _buildDaySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: List.generate(recipeSet['day'], (index) {
          int day = index + 1;
          bool isSelected = selectedDay == day;
          return GestureDetector(
            onTap: () {
              fetchData(recipeSet['id'],day);
              // setState(() => selectedDay = day);
            } ,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('第$day天',
                  style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
          );
        }),
      ),
    );
  }

Widget _buildMealCard(int mealType) {
  // 计算该餐总热量
  int totalCalories = recipes[mealType].fold(0, (sum, item) => sum + (item['foodCaloriesPerUnit']*item['quantity']  ?? 0) as int);

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 249, 249, 255),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 10)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          child: Image.network(
            // 如果第一道菜有图片，就用第一道菜的图片
            "https://i.postimg.cc/ZntHyhVK/food.jpg",
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(AliIcon.calorie2,
                      color: Color.fromARGB(208, 255, 103, 43), size: 18),
                  const SizedBox(width: 3),
                  Text('$totalCalories kcal',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      color: mealInfoMap[mealType]?['color'],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(mealInfoMap[mealType]?['label'],
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 循环渲染每一道菜
              Column(
                children: recipes[mealType].map<Widget>((food) {
                  return _buildFoodItem(
                    food['foodName'],
                    food['quantity'],
                    food['foodUnit'],
                    food['foodCaloriesPerUnit'] ?? 0,
                  ) ;
                }).toList()  ,
              )
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildFoodItem(String name, int quantity, String unit, int kcal) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://i.postimg.cc/ZntHyhVK/food.jpg',
                  height: 55,
                  width: 55,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  Text('${quantity}${unit}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 95, 80, 112))),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Icon(AliIcon.calorie2,
                  color: Color.fromARGB(250, 255, 143, 16), size: 14),
              const SizedBox(width: 3),
              Text('${quantity*kcal}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSetPlanButton() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(25)),
      alignment: Alignment.center,
      child: const Text('设置为我的食谱计划',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

// Delegate for SliverPersistentHeader
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }
}
