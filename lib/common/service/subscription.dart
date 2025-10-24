import 'dart:async';
import 'package:calorie/components/dialog/activating.dart';
import 'package:calorie/components/dialog/vip.dart';
import 'package:calorie/network/api.dart';
import 'package:calorie/store/store.dart';
import 'package:calorie/store/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// 订阅管理服务
class SubscriptionService {
  // 单例
  SubscriptionService._privateConstructor();
  static final SubscriptionService instance =
      SubscriptionService._privateConstructor();
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // 订阅产品列表
  List<ProductDetails> products = [];

  // 当前购买状态
  ValueNotifier<String?> error = ValueNotifier(null);
  ValueNotifier<PurchaseDetails?> latestPurchase = ValueNotifier(null);

  // 状态锁：防止重复验证和重复弹窗
  bool _isVerifying = false;
  bool _vipDialogShown = false;

  /// 初始化
  void init() {
    print('监听订阅状态...');
    UserInfo().getUserInfo();
    _subscription =
        _iap.purchaseStream.listen(_listenToPurchaseUpdated, onDone: () {
      _subscription.cancel();
    }, onError: (err) {
      error.value = err.toString();
    });
  }

  void dispose() {
    _subscription.cancel();
  }

  /// 查询产品
  Future<void> fetchProducts(Set<String> ids) async {
    Controller.c.showLoading();
    final response = await _iap.queryProductDetails(ids);
    if (response.notFoundIDs.isNotEmpty) {
      error.value = "Products not found: ${response.notFoundIDs.join(', ')}";
    }
    products = response.productDetails;
    Controller.c.hideLoading();
  }

  /// 发起购买
  Future<void> buy(ProductDetails product) async {
    Controller.c.showLoading();
    error.value = null;

    final purchaseParam = PurchaseParam(productDetails: product);

    try {
      if (product.id.contains("consumable")) {
        // 消耗型购买（一般订阅不用）
        await _iap.buyConsumable(purchaseParam: purchaseParam);
      } else {
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      error.value = e.toString();
      Controller.c.hideLoading();
    }
  }

  /// 监听购买状态
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      latestPurchase.value = purchase;
      print('status: ${purchase.status} ${purchase.productID}');

      switch (purchase.status) {
        case PurchaseStatus.purchased:
          // 只在未验证时触发一次
          if (!_isVerifying) {
            _isVerifying = true;

            // 显示“正在激活”弹窗
            Get.dialog(
              const ActivatingDialog(),
              barrierDismissible: false,
            );

            _verifyReceipt(purchase);
          }
          break;
        case PurchaseStatus.restored:
          break;
        case PurchaseStatus.pending:
          // 可选：展示等待UI
          break;

        case PurchaseStatus.error:
          error.value = purchase.error?.message ?? 'Unknown error';
          Controller.c.hideLoading();
          break;

        case PurchaseStatus.canceled:
          error.value = "Purchase canceled by user";
          Controller.c.hideLoading();
          break;
      }
    }
  }

  /// 上传 receipt 给后端验证
  Future<void> _verifyReceipt(PurchaseDetails purchase) async {
    try {
      final receipt = purchase.verificationData.serverVerificationData;
      print('receipt ${purchase.productID}');
      final response = await appleJwsVerify(receipt, purchase.productID, 'ios');
      print(' $response response');

      if (response.statusCode == 200) {
        Controller.c.hideLoading();
        print("Receipt verified successfully");

        // 关闭激活弹窗
        if (Get.isDialogOpen == true) Get.back();

        // 只弹出一次 VipDialog
        if (!_vipDialogShown) {
          _vipDialogShown = true;
          Future.delayed(const Duration(milliseconds: 200), () {
            Get.dialog(
              const VipDialog(),
              barrierDismissible: true,
            );
          });
        }

        // 更新用户信息
        UserInfo().getUserInfo();
      } else {
        error.value = "Receipt verification failed";
        Controller.c.hideLoading();
      }
    } catch (e) {
      error.value = e.toString();
      Controller.c.hideLoading();
    } finally {
      // _isVerifying = false;
    }
  }

  /// 恢复购买（换设备/重装用）
  Future<void> restorePurchases() async {
    Controller.c.showLoading();
    await _iap.restorePurchases();
  }

  /// （可选）重置状态锁
  void resetDialogState() {
    _vipDialogShown = false;
  }
}
