import 'package:calorie/common/icon/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BMICard extends StatelessWidget {
  final double bmi;
  const BMICard({super.key,required this.bmi});

  /// BMI 指针
  Widget _buildPointer(BuildContext context, double bmi) {
    double position;// 映射 BMI 到进度条范围 (15 - 35)
    if (bmi>29.5) {
      position = 0.725;
    }else if(bmi<15.5){
      position = 0.025 ;
    }else{
     position= (bmi - 15) / (35 - 15); 
    }
    // position = position.clamp(0.0, 0.79); // 限制范围

    return Positioned(
      left: position * MediaQuery.of(context).size.width ,
      child: const Icon(AliIcon.down,size: 8,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
              children: [
                Text(
                  "MY_BMI".tr,
                  style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                  
                ),
                const SizedBox(width: 8),
                Container(
                  padding:const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getBmiCategoryColor(bmi),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _getBmiCategory(bmi),
                    style:const TextStyle(fontSize: 11, color: Colors.white,fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
        const SizedBox(height: 8),
        Text(
          bmi.toStringAsFixed(1),
          style:const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              padding:const EdgeInsets.all(5),
              child: Row(
            children: [
              Expanded(
                flex: 1,
                child:  Container( 
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 86, 173, 244),
                  borderRadius: BorderRadius.circular(5),
                ), 
                height: 10),
              ),
              const SizedBox(width: 2,),
              Expanded(
                flex: 1,
                child:  Container( 
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 108, 235, 174),
                  borderRadius: BorderRadius.circular(5),
                ), 
                height: 10),
              ),
              const SizedBox(width: 2,),Expanded(
                flex: 1,
                child:  Container( 
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 82, 220, 51),
                  borderRadius: BorderRadius.circular(5),
                ), 
                height: 10),
              ),
              const SizedBox(width: 2,),Expanded(
                flex: 1,
                child:  Container( 
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 179, 64),
                  borderRadius: BorderRadius.circular(5),
                ), 
                height: 10),
              ),
              const SizedBox(width: 2,),Expanded(
                flex: 1,
                child:  Container( 
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 254, 97, 97),
                  borderRadius: BorderRadius.circular(5),
                ), 
                height: 10),
              ),
              const SizedBox(width: 2,),
            ],
          ),
            ),
          _buildPointer(context, bmi),
          
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLegend("UNDERWEIGHT".tr, Colors.blue),
            _buildLegend("HEALTHY".tr, const Color.fromARGB(255, 50, 222, 76)),
            _buildLegend("OVERWEIGHT".tr, const Color.fromARGB(255, 255, 185, 81)),
            _buildLegend("FAT2".tr, const Color.fromARGB(255, 255, 108, 98)),
          ],
        ),
      ],
    );
  }
}
  /// 构建分类标注
  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11,fontWeight: FontWeight.bold)),
      ],
    );
  }
    /// 分类文本颜色
  Color _getBmiCategoryColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 24) return const Color.fromARGB(255, 62, 230, 67);
    if (bmi < 28) return const Color.fromARGB(255, 255, 185, 81);
    return const Color.fromARGB(255, 255, 112, 101);
  }

  /// 获取 BMI 类别
  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return "UNDERWEIGHT".tr;
    if (bmi < 24) return "HEALTHY".tr;
    if (bmi < 28) return "OVERWEIGHT".tr;
    return "FAT2".tr;
  }