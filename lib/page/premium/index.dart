import 'package:calorie/common/icon/index.dart';
import 'package:calorie/components/video/horizontal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Premium extends StatefulWidget {
  const Premium({super.key});

  @override
  _PremiumState createState() => _PremiumState();
}

class _PremiumState extends State<Premium> {
  String selectedPlan = "yearly";
  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData(int id, int day) async {
    try {} catch (e) {
      print('$e error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        const HorizontalVideo(),
        Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 251, 249, 255)),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    AliIcon.vip3,
                    color: Colors.amber,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "VIP_TITLE".tr,
                    style: GoogleFonts.aDLaMDisplay(
                        fontSize: 18, fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 功能点列表
              Wrap(
                spacing: 24,
                runSpacing: 20,
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
              const SizedBox(height: 40),

              // 年付卡片
              _PlanCard(
                title: "Yearly Pro",
                price: "\$39.98",
                oldPrice: "\$139",
                subText: "\$0.77/Week",
                discountText: "70% OFF",
                selected: selectedPlan == "yearly",
                onTap: () => setState(() => selectedPlan = "yearly"),
              ),
              const SizedBox(height: 16),

              // 周付卡片
              _PlanCard(
                title: "Weekly Pro",
                price: "\$6.98",
                subText: "\$6.98/Week",
                selected: selectedPlan == "weekly",
                onTap: () => setState(() => selectedPlan = "weekly"),
              ),
            ],
          ),
        )
      ],
    )));
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
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String? oldPrice;
  final String subText;
  final String? discountText;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    this.oldPrice,
    required this.subText,
    this.discountText,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.redAccent : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          gradient: selected
              ? LinearGradient(colors: [Colors.orange.shade100, Colors.white])
              : null,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(price,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    if (oldPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        oldPrice!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 6),
                Text(subText, style: const TextStyle(color: Colors.grey)),
              ],
            ),

            // 折扣角标
            if (discountText != null)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    discountText!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
