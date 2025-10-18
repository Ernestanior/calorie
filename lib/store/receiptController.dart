import 'package:calorie/network/api.dart';
import 'package:get/get.dart';

class RecipeController extends GetxController {
  static RecipeController get r => Get.find();

  var recipeSets = [].obs;

  /// 模拟接口请求
  void fetchRecipes() async {
    try {
      final res = await recipeSetPage();
      if (res!= "-1") {
        recipeSets.value = res['content'];
        
      }else{
        print('error $res');
      }
    } catch (e) {

    }
  }
}