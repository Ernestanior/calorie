import 'package:calorie/network/api.dart';
import 'package:get/get.dart';

class RecipeController extends GetxController {
  static RecipeController get r => Get.find();

  var recipeSets = [].obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var isInitialized = false.obs;

  // 添加内存保护
  @override
  void onInit() {
    super.onInit();
    print('RecipeController initialized');
    isInitialized.value = true;
  }

  @override
  void onClose() {
    print('RecipeController closed');
    super.onClose();
  }

  /// 获取食谱数据
  void fetchRecipes() async {
    print(
        'RecipeController fetchRecipes called, isLoading: ${isLoading.value}');

    // 防止重复请求
    if (isLoading.value) return;

    isLoading.value = true;
    hasError.value = false;

    try {
      final res = await recipeSetPage();
      if (res != "-1" && res != null) {
        recipeSets.value = res['content'] ?? [];
        hasError.value = false;
        print('Recipe data loaded successfully: ${recipeSets.length} items');
      } else {
        print('Recipe API error: $res');
        hasError.value = true;
        recipeSets.value = [];
      }
    } catch (e) {
      print('Recipe fetch error: $e');
      hasError.value = true;
      recipeSets.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// 安全获取食谱数据（带重试机制）
  void safeFetchRecipes({int retryCount = 0}) async {
    if (retryCount >= 3) {
      print('Recipe fetch failed after 3 retries');
      hasError.value = true;
      return;
    }

    fetchRecipes();

    // 如果加载失败，延迟重试
    if (hasError.value && retryCount < 2) {
      print(
          'Recipe fetch failed, retrying in ${(retryCount + 1) * 2} seconds...');
      Future.delayed(Duration(seconds: (retryCount + 1) * 2), () {
        safeFetchRecipes(retryCount: retryCount + 1);
      });
    }
  }

  /// 重新加载数据
  void refreshRecipes() {
    print('RecipeController refreshRecipes called');
    recipeSets.clear();
    safeFetchRecipes();
  }

  /// 检查数据是否可用
  bool get hasData => recipeSets.isNotEmpty && !hasError.value;

  /// 强制重新初始化（用于解决内存问题）
  void forceReinitialize() {
    print('RecipeController forceReinitialize called');
    isInitialized.value = false;
    recipeSets.clear();
    isLoading.value = false;
    hasError.value = false;
    isInitialized.value = true;
    safeFetchRecipes();
  }
}
