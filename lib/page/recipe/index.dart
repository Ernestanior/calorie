import 'package:calorie/common/tabbar/index.dart';
import 'package:calorie/common/util/constants.dart';
import 'package:calorie/network/api.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'detail/index.dart';

class Recipe extends StatefulWidget {
  const Recipe({Key? key}) : super(key: key);

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> with SingleTickerProviderStateMixin {
  List recipeSets = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final res = await recipeSetPage();
      if (!mounted) return;
      if (res.isNotEmpty) {
        setState(() {
          recipeSets = res['content'];
        });
      }
    } catch (e) {
      print('$e error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(255, 236, 255, 237),
                  Color.fromARGB(255, 233, 255, 244),
                  Color.fromARGB(255, 225, 245, 255),
                  Color.fromARGB(255, 255, 241, 225),
                  Color.fromARGB(255, 255, 225, 225),
                  Color.fromARGB(255, 255, 255, 255)
                ],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 70),
                Text(
                  'RECIPE'.tr,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                ...recipeSets.map(
                  (item) => buildCard(
                      context: context,
                      imageUrl: 'https://i.postimg.cc/ZntHyhVK/food.jpg',
                      id:item['id'],
                      name: item['name'],
                      nameEn: item['nameEn'],
                      labelList: item['labelList'],
                      labelEnList: item['labelEnList'],
                      type: item['type'],
                      day: item['day'],
                      weight: item['weight'],
                      hot: item['hot'],
                      overlayColor: 0xB69B27B0),
                ),
                const SizedBox(
                  height: 70,
                )
              ],
            )));
    // CustomTabBar(),
    //     ],
    //   )
  }
}

Widget buildCard({
  required BuildContext context,
  required int id,
  required String imageUrl,
  required String name,
  required String nameEn,
  required int type,
  required int weight,
  required double hot,
  required int day,
  required List<dynamic> labelList,
  required List<dynamic> labelEnList,
  int overlayColor = 0xB52FA933,
}) {

  List weightType = [
    '',
    'LOSS'.tr,
    'GAIN'.tr,
  ];
  List displayLabel =Controller.c.lang.value == 'zh_CN' ? labelList : labelEnList;
  String displayName = Controller.c.lang.value == 'zh_CN' ? name : nameEn;
  String displayType = '${weightType[type]} ${weightList[weight]} ${'KG'.tr}';
  String displayDay = '$day ${'DAY'.tr}';
  String displayHot = '$hot ${'HOT_UNIT'.tr}';
  return GestureDetector(
    onTap: () => Get.to(RecipeDetail(), arguments: {'id':id,'name':displayName,'label':displayLabel,'weight':weightList[weight], 'type': weightType[type],'day':day,'hot':hot}),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(0, 0, 0, 0),
                    Color(overlayColor),
                    Color(overlayColor),
                    Color(overlayColor),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Wrap(
              spacing: 8,
              children: displayLabel
                  .map<Widget>((tag) => Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(111, 0, 0, 0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('$tag',
                            style:
                                const TextStyle(fontSize: 12, color: Colors.white)),
                      ))
                  .toList(),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.white, size: 14),
                    const SizedBox(width: 2),
                    Text(displayDay,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                    const SizedBox(width: 15),
                    const Icon(Icons.local_fire_department,
                        color: Colors.white, size: 15),
                    const SizedBox(width: 2),
                    Text(displayType,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                    const SizedBox(width: 15),
                    const Icon(Icons.group, color: Colors.white, size: 15),
                    const SizedBox(width: 2),
                    Text(displayHot,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
