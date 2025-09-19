import 'package:cached_network_image/cached_network_image.dart';
import 'package:calorie/common/icon/index.dart';
import 'package:calorie/common/tabbar/index.dart';
import 'package:calorie/common/util/constants.dart';
import 'package:calorie/network/api.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'detail/index.dart';

/// 1. 定义 Controller
class RecipeController extends GetxController {
  static RecipeController get r => Get.find();

  var recipeSets = [].obs;

  /// 模拟接口请求
  void fetchRecipes() async {
    try {
      final res = await recipeSetPage();
      recipeSets.value = res['content'];
    } catch (e) {}
  }
}

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage>
    with SingleTickerProviderStateMixin {
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
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'RECIPE'.tr,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/recipeCollect');
          },
          child: Row(
            children: [
              Icon(AliIcon.recipeSetting),
              const SizedBox(width: 5),
              Text(
                'MY_PLAN'.tr,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    const SizedBox(height: 15),

    // 👇 空状态
    if (RecipeController.r.recipeSets.isEmpty) Column(children: [
      const SizedBox(height: 100),
      Image.asset('assets/image/rice.png', height: 100),
      const SizedBox(height: 20),
      Text(
        'OOPS'.tr,
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 115, 115, 115),
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'NETWORK_ERROR'.tr,
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 115, 115, 115),
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'TRY_REFRESH'.tr,
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 115, 115, 115),
        ),
      ),
    ])
    // 👇 非空状态，生成卡片
    else ...RecipeController.r.recipeSets.map(
      (item) => buildCard(
        context: context,
        imageUrl: imgUrl + item['previewPhoto'],
        id: item['id'],
        name: item['name'],
        nameEn: item['nameEn'],
        labelList: item['labelList'],
        labelEnList: item['labelEnList'],
        type: item['type'],
        day: item['day'],
        weight: item['weight'],
        hot: item['hot'],
        overlayColor: int.parse(item['color']),
      ),
    ).toList(),

    const SizedBox(height: 100),
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
  List displayLabel =
      Controller.c.lang.value == 'zh_CN' ? labelList : labelEnList;
  String displayName = Controller.c.lang.value == 'zh_CN' ? name : nameEn;
  String displayType = '${weightType[type]} ${weightList[weight]} ${'KG'.tr}';
  String displayDay = '$day ${'DAY'.tr}';
  String displayHot = '$hot ${'HOT_UNIT'.tr}';
  return GestureDetector(
    onTap: () => Get.to(() => RecipeDetail(), arguments: {
      'id': id,
      'name': displayName,
      'imageUrl': imageUrl,
      'label': displayLabel,
      'weight': weightList[weight],
      'type': weightType[type],
      'day': day,
      'hot': hot
    }),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // image: DecorationImage(
        //   image: NetworkImage(imageUrl),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 255, 220, 204), // 蓝色背景
                highlightColor: Colors.white, // 扫光白色
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 255, 204, 232), // 固定蓝白背景
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
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
                borderRadius: BorderRadius.circular(10),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(151, 0, 0, 0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('$tag',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white)),
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
