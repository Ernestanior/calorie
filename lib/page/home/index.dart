import 'package:calorie/common/icon/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
    int currentDay = DateTime.now().weekday % 7;
    DateTime now = DateTime.now();

    late AnimationController _animationController;

    @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 1.0,
      upperBound: 1.2,
    )..repeat(reverse: true);

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // bottomNavigationBar: const BottomBar(),
      // floatingActionButton:  const FloatBtn(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            'Cal AI',
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
    padding: const EdgeInsets.only(top: 5, bottom: 0, left: 4, right: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        bool isFutureDate = fullDates[index].isAfter(now); // 判断是否是未来日期

        return GestureDetector(
          onTap: isFutureDate ? null : () { // 未来日期禁用点击
            setState(() {
              currentDay = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8),
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
                Container(
                  decoration: BoxDecoration(
                    color: index == currentDay && !isFutureDate 
                        ? Colors.white 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    '${dates[index]}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isFutureDate ? Colors.grey : Colors.black, // 未来日期变灰色
                      fontSize: 12,
                    ),
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
                percent: 0.7,
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
                      Text('731',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,fontFamily:'Helvetica'  )),
                      Text('/1800 kcal',style: TextStyle(fontSize: 16, color:Color.fromARGB(255, 141, 141, 141))),
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
          _buildNutrientCard('119g', 'PROTEIN'.tr, AliIcon.meat2, Colors.redAccent),
          _buildNutrientCard('180g', 'CARBOHYDRATE'.tr, AliIcon.dinner4, Colors.blueAccent),
          _buildNutrientCard('44g', 'FAT'.tr, AliIcon.fat, Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(String amount, String label, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
        padding: const EdgeInsets.symmetric(vertical: 18),
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
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.2),
              radius: 24,
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(height:18),
            Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11,fontWeight: FontWeight.bold)),
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
                  const SizedBox(height: 20,),
                    
                  Icon(AliIcon.empty1, color: const Color.fromARGB(255, 118, 190, 245).withOpacity(.7), size:50),

                  const SizedBox(height: 4,),
                  Text('NO_RECORD_TODAY'.tr,style: TextStyle(fontSize: 12,color: Color.fromARGB(255, 162, 162, 162)),),
                  const SizedBox(height: 100,),
              ],
            ),
          );
  }



}
