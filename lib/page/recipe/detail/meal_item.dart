import 'package:flutter/material.dart';

class MealItem extends StatelessWidget {
  final String mealType;
  final List<Map<String, dynamic>> items;

  const MealItem({required this.mealType, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image.network('https://i.postimg.cc/ZntHyhVK/food.jpg', width: double.infinity, height: 150, fit: BoxFit.cover),
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                child: Text(mealType, style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        Container(
          color: Colors.grey[100],
          padding: EdgeInsets.all(16),
          child: Column(
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network('https://i.postimg.cc/ZntHyhVK/food.jpg', width: 40, height: 40, fit: BoxFit.cover),
                    ),
                    SizedBox(width: 10),
                    Expanded(child: Text('${item['name']} ${item['portion']}', style: TextStyle(fontSize: 16))),
                    Text('${item['calories']} kcal', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
