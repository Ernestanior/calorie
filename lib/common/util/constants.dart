import 'dart:ui';
import 'package:calorie/common/icon/index.dart';
import 'package:get/get.dart';

// List mealOptions = [{'value':1,'label':"BREAKFAST".tr,'icon':AliIcon.breakfast,'color':const Color.fromARGB(255, 38, 225, 44)}, {'value':2,'label':"LUNCH".tr,'icon':AliIcon.lunch,'color':const Color.fromARGB(255, 255, 134, 73)},
//     {'value':3,'label':"DINNER".tr,'icon':AliIcon.supper,'color':const Color.fromARGB(255, 52, 157, 255)},{'value':4,'label':"SNACK".tr,'icon':AliIcon.extra,'color':const Color.fromARGB(255, 255, 80, 147)}];
    

List<Map<String, dynamic>> mealOptions() {
  return [
    {
      'value': 1,
      'label': "BREAKFAST".tr,
      'icon': AliIcon.breakfast,
      'color': const Color.fromARGB(255, 38, 225, 44)
    },
    {
      'value': 2,
      'label': "LUNCH".tr,
      'icon': AliIcon.lunch,
      'color': const Color.fromARGB(255, 255, 134, 73)
    },
    {
      'value': 3,
      'label': "DINNER".tr,
      'icon': AliIcon.supper,
      'color': const Color.fromARGB(255, 52, 157, 255)
    },
    {
      'value': 4,
      'label': "SNACK".tr,
      'icon': AliIcon.extra,
      'color': const Color.fromARGB(255, 255, 80, 147)
    },
  ];
}
final Map<int, Map<String, dynamic>> mealInfoMap = {
  for (var item in mealOptions())
    item['value'] as int: {
      'label': item['label'],
      'icon': item['icon'],
      'color': item['color'],
    }
};

Map<String, Map<String, String>> nutritionLabelMap(){
  return {
    "sugars": {"label": "SUGARS".tr, "unit": "g"},
    "dietaryFiber": {"label": "DIETARYFIBER".tr, "unit": "g"},
    "vitaminA": {"label": "VITAMINA".tr, "unit": "μg"},
    "vitaminB1": {"label": "VITAMINB1".tr, "unit": "mg"},
    "vitaminB2": {"label": "VITAMINB2".tr, "unit": "mg"},
    "vitaminB3": {"label": "VITAMINB3".tr, "unit": "mg"},
    "vitaminB5": {"label": "VITAMINB5".tr, "unit": "mg"},
    "vitaminB6": {"label": "VITAMINB6".tr, "unit": "mg"},
    "vitaminB7": {"label": "VITAMINB7".tr, "unit": "μg"},
    "vitaminB9": {"label": "VITAMINB9".tr, "unit": "μg"},
    "vitaminB12": {"label": "VITAMINB12".tr, "unit": "μg"},
    "vitaminC": {"label": "VITAMINC".tr, "unit": "mg"},
    "vitaminD": {"label": "VITAMIND".tr, "unit": "μg"},
    "vitaminE": {"label": "VITAMINE".tr, "unit": "mg"},
    "vitaminK": {"label": "VITAMINK".tr, "unit": "μg"},
    "sodium": {"label": "SODIUM".tr, "unit": "mg"},
    "potassium": {"label": "POTASSIUM".tr, "unit": "mg"},
    "calcium": {"label": "CALCIUM".tr, "unit": "mg"},
    "magnesium": {"label": "MAGNESIUM".tr, "unit": "mg"},
    "iron": {"label": "IRON".tr, "unit": "mg"},
    "zinc": {"label": "ZINC".tr, "unit": "mg"},
    "copper": {"label": "COPPER".tr, "unit": "mg"},
    "phosphorus": {"label": "PHOSPHORUS".tr, "unit": "mg"},
    "selenium": {"label": "SELENIUM".tr, "unit": "μg"},
    "manganese": {"label": "MANGANESE".tr, "unit": "mg"},
    "chloride": {"label": "CHLORIDE".tr, "unit": "mg"},
    "iodine": {"label": "IODINE".tr, "unit": "μg"},
  };
} 


  List weightList = [
    '0-1',
    '1-2',
    '2-4',
    '3-5',
    '4-6',
    '5-8'
  ];