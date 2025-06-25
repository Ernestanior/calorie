import 'dart:math';
import 'package:calorie/common/icon/index.dart';
import 'package:calorie/common/util/constants.dart';
import 'package:calorie/main.dart';
import 'package:calorie/network/api.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin,RouteAware{
    int currentDay = DateTime.now().weekday % 7;
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime.now();
    dynamic dailyData={'fat': 0, 'carbs': 0, 'calories': 0, 'protein': 0};
    List record = [];
    late AnimationController _animationController;

    @override
  void initState() {
    super.initState();
    fetchData(now);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 1.0,
      upperBound: 1.2,  
    )..repeat(reverse: true);
  }

  Future<void> fetchData(DateTime date) async {
    if (Controller.c.user['id'] is int) {
      final res = await dailyRecord(Controller.c.user['id'],DateFormat('yyyy-MM-dd').format(date));
      final records = await detectionList(1,5,date:DateFormat('yyyy-MM-dd').format(date));
      setState(() {
        dailyData=res;
        record=records['content'];
      });
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
    _animationController.dispose();
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 140, 197, 255),Color.fromARGB(255, 155, 205, 255),Color.fromARGB(255, 181, 218, 255), Color.fromARGB(255, 176, 215, 255),Color.fromARGB(255, 227, 241, 255),Color.fromARGB(255, 228, 255, 240),Colors.white,Colors.white],
          ),

        ),
        child:       
          SingleChildScrollView(        
            child: Column(
              children: [
                const SizedBox(height: 50,),
                _buildAppBar(),
                _buildDateSelector(),
                _buildSummaryCard(),
                _buildNutrientCards(),
                _buildHistoryRecord(),
              ],
            ),
          ),
      )

    );
  }

 Widget _buildAppBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(width: 8),
          Text(
            'MealAI',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() { 
  List<String> days = ['SUNDAY'.tr, 'MONDAY'.tr, 'TUESDAY'.tr, 'WEDNESDAY'.tr, 'THURSDAY'.tr, 'FRIDAY'.tr, 'SATURDAY'.tr];
  DateTime now = DateTime.now(); // 当前日期
  List<int> dates = List.generate(7, (index) => now.subtract(Duration(days: now.weekday % 7 - index)).day);
  List<DateTime> fullDates = List.generate(7, (index) => now.subtract(Duration(days: now.weekday % 7 - index))); // 计算完整日期

  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(100, 255, 255, 255),
      borderRadius: BorderRadius.circular(10),


      border: Border.all(width: 1, color: const Color.fromARGB(150, 255, 255, 255)),
    ),
    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 4, right: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        bool isFutureDate = fullDates[index].isAfter(now); // 判断是否是未来日期

        return GestureDetector(
          onTap: isFutureDate ? null : () { // 未来日期禁用点击
          fetchData(fullDates[index]);
            setState(() {
              currentDate=fullDates[index];
              currentDay = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                    color: index == currentDay && !isFutureDate 
                        ? Colors.white 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
            child: Column(
              children: [
                Text( 
                  days[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isFutureDate ? Colors.grey : Colors.black, // 未来日期变灰色
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${dates[index]}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isFutureDate ? Colors.grey : Colors.black, // 未来日期变灰色
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
    return Padding(
      padding: const EdgeInsets.only( top: 10),
      child: CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 18.0,
                animation: true,
                percent: min(1,dailyData['calories']/Controller.c.user['dailyCalories']),
                center: Container(
                  margin:const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(150, 255, 255, 255),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Container(
                    width: double.infinity,
                  margin:const EdgeInsets.all(15),
                  padding:const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(150, 255, 255, 255),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('CALORIE'.tr,style: const TextStyle(fontSize: 18, color:Color.fromARGB(255, 148, 148, 148)),),
                      Text('${dailyData['calories']}',style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontFamily:'Helvetica'  )),
                      Text('/${Controller.c.user['dailyCalories']} kcal',style: const TextStyle(fontSize: 16, color:Color.fromARGB(255, 141, 141, 141))),
                    ],
                  ),
                  ) ,
                ),
                circularStrokeCap: CircularStrokeCap.round,
                arcType: ArcType.FULL,
                arcBackgroundColor: const Color.fromARGB(150, 255, 255, 255),
                backgroundColor: Colors.pink,
                progressBorderColor: const Color.fromARGB(150, 255, 255, 255),
                progressColor: const Color.fromARGB(255, 99, 188, 240),
              )
    );
  }
  Widget _buildNutrientCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNutrientCard(Controller.c.user['dailyProtein'],dailyData['protein'], 'PROTEIN'.tr, AliIcon.fat, const Color.fromARGB(255, 255, 207, 119)),
          _buildNutrientCard(Controller.c.user['dailyCarbs'],dailyData['carbs'], 'CARBOHYDRATE'.tr, AliIcon.dinner4, const Color.fromARGB(255, 95, 154, 255)),
          _buildNutrientCard(Controller.c.user['dailyFats'],dailyData['fat'], 'FAT'.tr, AliIcon.meat2, const Color.fromARGB(255, 255, 122, 122)),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(int total,int eat, String label, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(
              color:  Color.fromARGB(31, 99, 99, 99),
              blurRadius: 4,
              spreadRadius: 2,
            ),]
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle( fontSize: 11,fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CircularPercentIndicator(
                radius: 30.0,
                lineWidth: 5.0,
                animation: true,
                percent: min(1,eat/total),
                center:CircleAvatar(
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
            const SizedBox(height:5),
            Text('REMAINING'.tr, style: const TextStyle(color: Color.fromARGB(255, 61, 61, 61),fontSize: 10)),
            const SizedBox(height: 3),
            Text('${max(0, total-eat)}', style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
  Widget _buildHistoryRecord() {
    return Container(
            width: double.infinity,
            padding:const EdgeInsets.only(top: 15,bottom: 35, left: 20, right: 20, ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight:Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color:Color.fromARGB(31, 204, 204, 204),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: Offset(0, -10)
                ),
              ],
            ),
            child: Column(
              children: [
                  Row(children: [
                  Text('MY_RECORD'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.left,),
                ],), 
                  const SizedBox(height: 10,),
                    _buildRecordList()

              ],
            ),
          );
  }  
  Widget _buildRecordList() {
    if (record.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Icon(AliIcon.empty1, color: const Color.fromARGB(255, 118, 190, 245).withOpacity(.7), size:50),
            const SizedBox(height: 4,),
            Text('NO_RECORD_TODAY'.tr,style: const TextStyle(fontSize: 12,color: Color.fromARGB(255, 162, 162, 162)),),
            const SizedBox(height: 100,),
          ],
        ),
      );
    }else{
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: record.map((item){
            final meal = mealInfoMap[item['mealType']];
            return GestureDetector(
              onTap: (){
                Controller.c.foodDetail(item);
                Navigator.pushNamed(context,'/foodDetail');
              },
              child:   Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color:const Color.fromARGB(255, 247, 249, 255)),
              child: Row(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(item['sourceImg'],fit: BoxFit.cover,),
                ),
                Expanded(
                  child:  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child:      
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Container(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Text(item['detectionResultData']['total']?['dishName'] ?? "food",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                        ],),
                        Row(
                          children: [
                          const Icon(AliIcon.calorie, size: 20, color: Color.fromARGB(255, 255, 133, 25)),
                          const SizedBox(width: 2,),
                          Text("${item['detectionResultData']['total']?['calories']} ${'KCAL'.tr}",style: TextStyle(fontWeight: FontWeight.w600),),
                        ],),
                      ],
                    ),
                    ),   
                    SizedBox(height: 8,),            

                    Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: meal?['color'] ?? const Color.fromARGB(255, 122, 226, 114),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(meal?['label']??'DINNER'.tr,style: TextStyle(fontSize: 10,color:Colors.white),),
                          ),
                    SizedBox(height: 8,),            
                    Row(
                      children: [
                        const Icon(AliIcon.fat, size: 16, color: Color.fromARGB(255, 255, 204, 109)),
                        const SizedBox(width: 2,),
                        Text("${item['detectionResultData']['total']?['protein']}${'G'.tr}",style: TextStyle(fontSize: 11),),
                        const SizedBox(width: 10,),
                        const Icon(AliIcon.dinner4, size: 16, color: Color.fromARGB(255, 102, 166, 255)),
                        const SizedBox(width: 2,),
                        Text("${item['detectionResultData']['total']?['carbs']}${'G'.tr}",style: TextStyle(fontSize: 11),),
                        const SizedBox(width: 10,),
                        const Icon(AliIcon.meat2, size: 16, color: Color.fromARGB(255, 255, 124, 124)),
                        const SizedBox(width: 2,),
                        Text("${item['detectionResultData']['total']?['fat']}${'G'.tr}",style: TextStyle(fontSize: 11),),
                      ],
                    ),
                  ],),
                )
                ) ,
              ],
            )),
            );
          }
            ).toList()
        ),
      );
    }
    

  }



}
