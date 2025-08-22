class MealDataHelper {
  /// mealType: 1=早餐, 2=午餐, 3=晚餐
  static Map groupMealsByType(List data) {
    // 结果容器
    Map result = {};

    for (var item in data) {
      int type = item["mealType"];

        if (!result.containsKey(type)) {
          result[type] = [];
        }
        result[type]!.add(item);
    }

    return result;
  }
}
