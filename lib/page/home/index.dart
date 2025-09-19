import 'dart:io';
import 'dart:math';
import 'package:calorie/common/icon/index.dart';
import 'package:calorie/common/tabbar/index.dart';
import 'package:calorie/common/util/constants.dart';
import 'package:calorie/components/imgSwitcher/index.dart';
import 'package:calorie/components/lottieFood/index.dart';
import 'package:calorie/main.dart';
import 'package:calorie/network/api.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, RouteAware {
  int currentDay = DateTime.now().weekday % 7;
  DateTime now = DateTime.now();
  DateTime currentDate = DateTime.now();
  dynamic dailyData = {'fat': 0, 'carbs': 0, 'calories': 0, 'protein': 0};
  List record = [];
  late Worker _homeDataWorker;

  @override
  void initState() {
    super.initState();
    fetchData(now);
    // 监听触发器，触发后刷新数据
    // 保存 worker 引用
    _homeDataWorker = ever(Controller.c.refreshHomeDataTrigger, (triggered) {
      if (triggered == true) {
        fetchData(DateTime.now());
        Controller.c.refreshHomeDataTrigger.value = false;
      }
    });
  }

  Future<void> fetchData(DateTime date) async {
    if (Controller.c.user['id'] is int) {
      try {
        final res = await dailyRecord(
            Controller.c.user['id'], DateFormat('yyyy-MM-dd').format(date));
        final records = await detectionList(1, 18,
            date: DateFormat('yyyy-MM-dd').format(date));
        if (!mounted) return;
        if (res != "-1") {
          setState(() {
            dailyData = res;
          });
        }
        if (records.isNotEmpty) {
          setState(() {
            record = records['content'];
          });
        }
      } catch (e) {
        print('$e error');
      }

      // final dayList = await detectionList();
    }
  }

  @override
  void didPopNext() {
    // 从页面B返回后触发
    fetchData(currentDate); // 重新拉取数据
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 注册路由观察者
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _homeDataWorker.dispose(); // ✅ 取消监听，防止页面销毁后还触发回调
    // 移除观察者
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 191, 212, 255),
                Color.fromARGB(255, 175, 195, 255),
                Color.fromARGB(255, 191, 222, 255),
                Color.fromARGB(255, 205, 230, 255),
                Color.fromARGB(255, 212, 235, 255),
                Color.fromARGB(255, 249, 238, 255),
                Colors.white,
                Colors.white
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                _buildAppBar(),
                _buildDateSelector(),
                const SizedBox(
                  height: 5,
                ),
                _buildSummaryCard(),
                _buildNutrientCards(),
                _buildHistoryRecord(),
              ],
            ),
          ),
        ));
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // const Icon(AliIcon.canju2,size: 28,color: Color.fromARGB(255, 2, 119, 170),),
          // SizedBox(width: 4),

          Text(
            'Vita AI',
            style: GoogleFonts.afacad(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    List<String> days = [
      'SUNDAY'.tr,
      'MONDAY'.tr,
      'TUESDAY'.tr,
      'WEDNESDAY'.tr,
      'THURSDAY'.tr,
      'FRIDAY'.tr,
      'SATURDAY'.tr
    ];
    DateTime now = DateTime.now(); // 当前日期
    List<int> dates = List.generate(7,
        (index) => now.subtract(Duration(days: now.weekday % 7 - index)).day);
    List<DateTime> fullDates = List.generate(
        7,
        (index) =>
            now.subtract(Duration(days: now.weekday % 7 - index))); // 计算完整日期

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(100, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            width: 1, color: const Color.fromARGB(150, 255, 255, 255)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 4, right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          bool isFutureDate = fullDates[index].isAfter(now); // 判断是否是未来日期

          return GestureDetector(
            onTap: isFutureDate
                ? null
                : () {
                    // 未来日期禁用点击
                    fetchData(fullDates[index]);
                    setState(() {
                      currentDate = fullDates[index];
                      currentDay = index;
                    });
                  },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: index == currentDay && !isFutureDate
                    ? Colors.white
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    days[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          isFutureDate ? Colors.grey : Colors.black, // 未来日期变灰色
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dates[index]}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          isFutureDate ? Colors.grey : Colors.black, // 未来日期变灰色
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSummaryCard() {

    return CircularPercentIndicator(
      radius: 100.0,
      lineWidth: 15.0,
      animation: true,
      percent:
          min(1, dailyData['calories'] / Controller.c.user['dailyCalories']),
      center: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(150, 255, 255, 255),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(150, 255, 255, 255),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CALORIE'.tr,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 115, 115, 115)),
              ),
              Text('${dailyData['calories']}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  )),
              Text('/${Controller.c.user['dailyCalories']} ${'KCAL'.tr}',
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 141, 141, 141))),
            ],
          ),
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      arcType: ArcType.FULL,
      arcBackgroundColor: const Color.fromARGB(150, 255, 255, 255),
      backgroundColor: Colors.pink,
      progressBorderColor: const Color.fromARGB(150, 255, 255, 255),
      progressColor: const Color.fromARGB(255, 99, 188, 240),
    );
  }

  Widget _buildNutrientCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNutrientCard(
              Controller.c.user['dailyProtein'],
              dailyData['protein'],
              'PROTEIN'.tr,
              AliIcon.fat,
              const Color.fromARGB(255, 255, 181, 71)),
          _buildNutrientCard(
              Controller.c.user['dailyCarbs'],
              dailyData['carbs'],
              'CARBS'.tr,
              AliIcon.dinner4,
              const Color.fromARGB(255, 95, 154, 255)),
          _buildNutrientCard(
              Controller.c.user['dailyFats'],
              dailyData['fat'],
              'FAT'.tr,
              AliIcon.meat2,
              const Color.fromARGB(255, 255, 122, 122)),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(
      int total, int eat, String label, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 14),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(31, 173, 173, 173),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ]),
        child: Column(
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            CircularPercentIndicator(
              radius: 30.0,
              lineWidth: 5.0,
              animation: true,
              percent: min(1, eat / total),
              center: CircleAvatar(
                backgroundColor: iconColor.withOpacity(0.2),
                radius: 24,
                child: Icon(icon, size: 24, color: iconColor),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              arcType: ArcType.FULL,
              arcBackgroundColor: const Color.fromARGB(150, 255, 255, 255),
              backgroundColor: Colors.pink,
              progressBorderColor: const Color.fromARGB(150, 255, 255, 255),
              progressColor: iconColor,
            ),
            const SizedBox(height: 5),
            Text('REMAINING'.tr,
                style: const TextStyle(
                    color: Color.fromARGB(255, 61, 61, 61), fontSize: 11)),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${max(0, total - eat)}',
                    style: const TextStyle(fontSize: 14)),
                Text(' ${'G'.tr}', style: const TextStyle(fontSize: 12)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzingTask() {
    return Obx(() {
      if (!Controller.c.isAnalyzing.value ||
          Controller.c.analyzingFilePath.value == '') {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 247, 249, 255),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    child: Obx(() => Image.file(
                          File(Controller.c.analyzingFilePath.value),
                          fit: BoxFit.cover,
                          color: Color.fromARGB(60, 0, 0, 0), // 👈 半透明灰色
                          colorBlendMode: BlendMode.darken,
                        )),
                  ),
                  Obx(() {
                    final progress = Controller.c.analyzingProgress.value;
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: progress),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, animatedValue, child) {
                        return SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: animatedValue,
                            strokeWidth: 6,
                            backgroundColor:
                                const Color.fromARGB(255, 161, 161, 161),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 255, 255, 255)),
                          ),
                        );
                      },
                    );
                  }),
                  Obx(() {
                    final progress = Controller.c.analyzingProgress.value;
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: progress),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, animatedValue, child) {
                        return Text(
                          "${(animatedValue * 100).toInt()}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ANALYZING_2".tr,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 10),
                  const LottieFood(), // 你已有的动画组件
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHistoryRecord() {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.35, // 至少半屏高
      ),
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 15,
        bottom: 30,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(31, 204, 204, 204),
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, -10)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MY_RECORD'.tr,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.left,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'records');
                },
                child: Text(
                  '${'MORE'.tr} > ',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.left,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          _buildAnalyzingTask(),
          _buildRecordList(),
        ],
      ),
    );
  }

  Widget _buildRecordList() {
    if (record.isEmpty && !Controller.c.isAnalyzing.value ) {
      return Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 247, 249, 255)),
                  child: Row(
                    children: [
                      const ImageSwitcher(),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(AliIcon.calorie,
                                      size: 20,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'UPLOAD_YOUR_FOOD'.tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "CLICK".tr,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  const Icon(AliIcon.camera),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "BUTTON".tr,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        );
        
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(bottom: 50),
        child: Column(
            children: record.map((item) {
          final meal = mealInfoMap[item['mealType']];
          return GestureDetector(
            onTap: () {
              Controller.c.foodDetail(item);
              Navigator.pushNamed(context, '/foodDetail');
            },
            child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 247, 249, 255)),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                        item['sourceImg'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 130,
                                      child: Text(
                                        (item['detectionResultData']['total']
                                                        ?['dishName'] ??
                                                    '')
                                                .toString()
                                                .trim()
                                                .isEmpty
                                            ? 'UNKNOWN_FOOD'.tr
                                            : item['detectionResultData']
                                                ['total']?['dishName'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(AliIcon.calorie,
                                        size: 20,
                                        color:
                                            Color.fromARGB(255, 255, 133, 25)),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "${item['detectionResultData']['total']?['calories'] ?? 0} ${'KCAL'.tr}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: meal?['color'] ??
                                  const Color.fromARGB(255, 122, 226, 114),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              meal?['label'] ?? 'DINNER'.tr,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Icon(AliIcon.fat,
                                  size: 16,
                                  color: Color.fromARGB(255, 255, 204, 109)),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                "${item['detectionResultData']['total']?['protein'] ?? 0}${'G'.tr}",
                                style: TextStyle(fontSize: 11),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(AliIcon.dinner4,
                                  size: 16,
                                  color: Color.fromARGB(255, 102, 166, 255)),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                "${item['detectionResultData']['total']?['carbs'] ?? 0}${'G'.tr}",
                                style: TextStyle(fontSize: 11),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(AliIcon.meat2,
                                  size: 16,
                                  color: Color.fromARGB(255, 255, 124, 124)),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                "${item['detectionResultData']['total']?['fat'] ?? 0}${'G'.tr}",
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                  ],
                )),
          );
        }).toList()),
      );
    }
  }
}
