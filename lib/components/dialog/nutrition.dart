import 'package:calorie/common/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';



Future<void> showNutritionInfoDialog(BuildContext context, String key) async {
  final info = nutritionLabelMap()[key];
  if (info == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cannot find this nutrient element')),
    );
    return;
  }

  await showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  info["label"] ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 描述
            Text(
              info["desc"] ?? "",
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            const SizedBox(height: 16),

            _buildSection("MAIN_BENEFITS".tr, info["benefits"]),
            _buildSection("RISKS".tr, info["risks"]),
            _buildSection("SOURCES".tr, info["sources"]),

            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${'UNIT'.tr}：${info["unitTranslate"]}",
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSection(String title, String? content) {
  if (content == null || content.isEmpty) return const SizedBox.shrink();
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
      ],
    ),
  );
}
