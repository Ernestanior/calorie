import 'package:calorie/common/icon/index.dart';
import 'package:calorie/common/service/subscription.dart';
import 'package:calorie/components/dialog/activating.dart';
import 'package:calorie/components/dialog/discount.dart';
import 'package:calorie/components/dialog/vip.dart';
import 'package:calorie/components/loading/index.dart';
import 'package:calorie/components/video/horizontal.dart';
import 'package:calorie/page/premium/table.dart';
import 'package:calorie/store/store.dart';
import 'package:calorie/store/timeController.dart';
import 'package:calorie/store/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Premium extends StatefulWidget {
  const Premium({super.key});

  @override
  _PremiumState createState() => _PremiumState();
}

class _PremiumState extends State<Premium> {
  String selectedPlan = "yearlyPro";

  Map<String, String> getCurrentPlan(int vipStatus) {
    switch (vipStatus) {
      case 1:
        return {
          'name': 'PRO_TRIAL_MEMBER'.tr,
          'desc': 'PRO_TRIAL_MEMBER_DESC'.tr,
        };
      case 2:
        return {
          'name': 'PRO_MONTHLY_PLAN'.tr,
          'desc': 'PRO_MONTHLY_PLAN_DESC'.tr,
        };
      case 3:
        return {
          'name': 'PRO_ANNUAL_PLAN'.tr,
          'desc': 'PRO_ANNUAL_PLAN_DESC'.tr,
        };

      default:
        return {
          'name': 'BASIC_MEMBER'.tr,
          'desc': 'BASIC_MEMBER_DESC'.tr,
        };
    }
  }

  @override
  void initState() {
    super.initState();

    SubscriptionService.instance.init();
    SubscriptionService.instance.fetchProducts({'monthPro', 'yearlyPro'});
  }

  @override
  void dispose() {
    SubscriptionService.instance.dispose();
    super.dispose();
  }

  Future<void> fetchData(int id, int day) async {
    try {} catch (e) {
      print('$e error');
    }
  }

  Map<String, String> getPrice(String productId) {
  final product = SubscriptionService.instance.products
      .firstWhereOrNull((p) => p.id == productId);
      print(product?.price);
      print(product?.rawPrice);
      print(product?.currencyCode);
      print(product?.title);
      if(productId=='yearlyPro'){
  return ({
    'price':'${product?.price}',
    'discountPrice':'${product?.rawPrice} ${product?.currencyCode}' ,
    'weeklyPrice':((product?.rawPrice ?? 0) / 52 ).toStringAsFixed(2),
    
    'weeklyDiscountPrice':((product?.rawPrice ?? 0) / 52 ).toStringAsFixed(2)
  });
      }else{
          return ({
    'price':'${product?.price}',
    'discountPrice':'${product?.rawPrice} ${product?.currencyCode}' ,
    'weeklyPrice':((product?.rawPrice ?? 0) / 4 ).toStringAsFixed(2),
    'weeklyDiscountPrice':((product?.rawPrice ?? 0) / 4 ).toStringAsFixed(2)
  });
      }

}


  @override
  Widget build(BuildContext context) {
    final service = SubscriptionService.instance;
    dynamic user = Controller.c.user;
    // 取 vipStatus
    int vipStatus = user['vipStatus'] ?? 0;
    int vipAutoRenew = user['autoRenew'] ?? 0;
    int vipExpire =
        DateTime.parse(user['expireDateTime']).millisecondsSinceEpoch;
    int nowStamp = DateTime.now().millisecondsSinceEpoch;
    final plan = getCurrentPlan(vipStatus);

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 237, 223),
        body: Stack(
          children: [
            Stack(children: [
              SingleChildScrollView(
                  child: Column(
                children: [
                  const HorizontalVideo(),
                  Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 255, 253, 249),
                            Color.fromARGB(255, 255, 237, 223)
                          ],
                        ),
                        color: Color.fromARGB(255, 255, 253, 248)),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 203, 164),
                                  width: 2)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // const Icon(
                              //   AliIcon.vip3,
                              //   color: Colors.amber,
                              // ),
                              Image.asset(
                                'assets/image/vip.jpeg',
                                width: 36,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "VIP_TITLE".tr,
                                style: GoogleFonts.ubuntu(
                                    fontSize: 18, fontWeight: FontWeight.w900),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // 功能点列表
                        Wrap(
                          spacing: 28,
                          runSpacing: 25,
                          alignment: WrapAlignment.center,
                          children: [
                            _FeatureItem(
                                icon: AliIcon.scan2,
                                color: const Color.fromARGB(255, 144, 144, 144),
                                title: "VIP_FEATURE_1".tr,
                                subtitle: "VIP_FEATURE_1_DESC".tr),
                            _FeatureItem(
                                icon: AliIcon.running2,
                                color: const Color.fromARGB(255, 69, 69, 69),
                                title: "VIP_FEATURE_2".tr,
                                subtitle: "VIP_FEATURE_2_DESC".tr),
                            _FeatureItem(
                                icon: AliIcon.recipeBook2,
                                color: const Color.fromARGB(255, 122, 122, 122),
                                title: "VIP_FEATURE_3".tr,
                                subtitle: "VIP_FEATURE_3_DESC".tr),
                            _FeatureItem(
                                icon: AliIcon.weightScale,
                                color: const Color.fromARGB(255, 140, 140, 140),
                                title: "VIP_FEATURE_4".tr,
                                subtitle: "VIP_FEATURE_4_DESC".tr),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // if (isVip)
                        //   Container(
                        //       width: double.infinity,
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(16),
                        //           border: Border.all(
                        //               color: const Color.fromARGB(255, 70, 10, 202),
                        //               width: 3),
                        //           gradient: const LinearGradient(colors: [
                        //             Color.fromARGB(255, 236, 212, 255),
                        //             Color.fromARGB(255, 255, 244, 221)
                        //           ])),
                        //       padding: const EdgeInsets.symmetric(vertical: 20),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             '${"CURRENT_PLAN".tr}  ',
                        //             style: GoogleFonts.aDLaMDisplay(
                        //                 fontWeight: FontWeight.bold, fontSize: 17),
                        //           ),
                        //           Text(
                        //             'YEARLY_PRO'.tr,
                        //             style: GoogleFonts.aBeeZee(
                        //                 fontWeight: FontWeight.bold, fontSize: 16),
                        //           ),
                        //         ],
                        //       )),

                        (nowStamp < vipExpire && vipStatus > 0)
                            ? Stack(
                                children: [
                                  Image.asset('assets/image/goldCard_1.png'),
                                  Positioned(
                                    top: 30,
                                    right: 20,
                                    child: Text(
                                      'ACTIVE_PLAN'.tr,
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255, 122, 90, 34),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 45,
                                      left: 0,
                                      right: 0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            plan['name'] ?? "",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 146, 95, 8),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            plan['desc'] ?? "",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromARGB(
                                                    255, 114, 95, 71)),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            '${'VALID_UNTIL'.tr} 2026.10.06',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: const Color.fromARGB(
                                                    255, 172, 153, 129)),
                                          ),
                                        ],
                                      ))
                                ],
                              )
                            : SizedBox.shrink(),
                        const SizedBox(height: 10),
                        VipFeatures(),
                        const SizedBox(height: 15),

                        Column(
                          children: [
                            (vipAutoRenew == 0 ||
                                    nowStamp > vipExpire ||
                                    vipStatus < 3)
                                ? _PlanCard(
                                    id:'yearlyPro',
                                    title: 'YEARLY_PRO'.tr,
                                    tip:'AUTO_RENEWING'.tr,
                                    price: getPrice('yearlyPro')['price'],
                                    weeklyPrice: getPrice('yearlyPro')['weeklyPrice'],
                                    discountPrice: getPrice('yearlyPro')['discountPrice'],
                                    weeklyDiscountPrice: getPrice('yearlyPro')['weeklyDiscountPrice'],
                                    selected: selectedPlan == "yearlyPro",
                                    onTap: () => setState(
                                        () => selectedPlan = "yearlyPro"),
                                  )
                                : SizedBox.shrink(),
                            const SizedBox(height: 16),

                            // 周付卡片
                            (vipAutoRenew == 0 ||
                                    nowStamp > vipExpire ||
                                    vipStatus < 2)
                                ? _PlanCard(
                                    id:'monthPro',
                                    title: 'MONTHLY_PRO'.tr,
                                    tip:'NON_RENEWING'.tr,
                                    price: getPrice('monthPro')['price'],
                                    weeklyPrice: getPrice('monthPro')['weeklyPrice'],
                                    discountPrice: getPrice('monthPro')['discountPrice'],
                                    weeklyDiscountPrice: getPrice('monthPro')['weeklyDiscountPrice'],
                                    selected: selectedPlan == "monthPro",
                                    onTap: () => setState(
                                        () => selectedPlan = "monthPro"),
                                  )
                                : SizedBox.shrink(),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              )),
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 20,
                child: GestureDetector(
                  onTap: () => {
                    if (TimerController.t.offerStatus.value)
                      {Navigator.pop(context)}
                    else
                      {
                        if ((vipAutoRenew == 0 ||
                            nowStamp > vipExpire ||
                            vipStatus < 3))
                          {
                            TimerController.t.offerStatus(true),
                            TimerController.t.startRemaining(),
                            Get.dialog(
                              const DiscountDialog(),
                              barrierDismissible: true,
                            )
                          }
                        else
                          {Navigator.pop(context)}
                      }
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color.fromARGB(130, 51, 51, 51),
                    child: Icon(AliIcon.back2, color: Colors.white, size: 26),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () { 
                    if (selectedPlan == 'monthPro') {
                      service.buy(service.products[0]);
                    } else {
                      service.buy(service.products[1]);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(229, 9, 1, 28),
                        borderRadius: BorderRadius.circular(25)),
                    alignment: Alignment.center,
                    child: Text('NEXT'.tr,
                        style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              )
            ]),
            Obx(() {
              if (Controller.c.isLoading) {
                return LottieLoading(
                  size: 30,
                  spacing: 25,
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ));
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? color;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(
            height: 2,
          ),
          Text(title, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 2,
          ),
          Text(subtitle,
              style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String id;
  final String title;
  final String tip;
  final String? price;
  final String? weeklyPrice;
  final String? discountPrice;
  final String? weeklyDiscountPrice;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.id,
    required this.title,
    required this.tip,
    required this.price,
    required this.weeklyPrice,
    required this.discountPrice,
    required this.weeklyDiscountPrice,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(31, 146, 146, 146),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected
                      ? const Color.fromARGB(0, 255, 255, 255)
                      : Colors.grey.shade300,
                  width: 0,
                ),
                gradient: selected
                    ? const LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                            Color(0xFFEAC794),
                            Color(0xFFEACB98),
                            Color(0xFFFBE8BF),
                            Color(0xFFFEF7E3),
                            Color(0xFFFBE8BF),
                            Color(0xFFEACB98),
                            Color(0xFFEAC794),
                          ])
                    : const LinearGradient(
                        colors: [Colors.white, Colors.white]),
              ),
              child: // 优惠栏，用 offerStatus 控制显示
                  Column(
                children: [
                  Obx(() {
                    final minutes =
                        (TimerController.t.remainingSeconds.value ~/ 60)
                            .toString()
                            .padLeft(2, '0');
                    final seconds =
                        (TimerController.t.remainingSeconds.value % 60)
                            .toString()
                            .padLeft(2, '0');

                    if (TimerController.t.offerStatus.value && title == '') {
                      return ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(9),
                            topRight: Radius.circular(9)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Color.fromARGB(255, 187, 134, 55),
                                Color.fromARGB(255, 234, 195, 105),
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.flash_on,
                                      color: Colors.white, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    "LIMITED_TIME_OFF".tr,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("${"ENDS_IN".tr} ",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      minutes,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                  const Text(" : ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      seconds,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  // 标题和价格部分
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(title,
                            style: GoogleFonts.ubuntu(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: selected
                                  ? const Color.fromARGB(255, 113, 73, 5)
                                  : Colors.black,
                            )),
                            Text('* $tip',
                            style: GoogleFonts.ubuntu(
                              fontSize: 11,
                              color: selected
                                  ? const Color.fromARGB(255, 113, 73, 5)
                                  : Colors.black,
                            )),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              if (TimerController.t.offerStatus.value &&
                                  id == 'yearlyPro') {
                                return Column(
                                  children: [
                                    Text(
                                        "${discountPrice}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 130, 94, 62))),
                                    Text(
                                      "$price",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    )
                                  ],
                                );
                              }
                              return Text("${price}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 130, 94, 62)));
                            }),
                            Column(children: [
                              Text(
                                  "\$ ${(weeklyDiscountPrice)} / ${'WEEK'.tr}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Obx(() {
                                if (TimerController.t.offerStatus.value &&
                                    id == 'yearlyPro') {
                                  return Text(
                                    "$weeklyPrice / ${'WEEK'.tr}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              })
                            ])
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
