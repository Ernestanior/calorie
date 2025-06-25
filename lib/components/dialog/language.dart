import 'package:calorie/common/util/utils.dart';
import 'package:flutter/material.dart';

void showLanguageDialog(BuildContext context, String currentLangCode, Function(dynamic) onSelect) {
  showDialog(
    context: context,
    barrierDismissible: true, // 点击外部可关闭
    barrierColor: Colors.black.withOpacity(0.4), // 背景灰色遮罩
    builder: (context) {
      return Center(
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          elevation: 16,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            constraints: const BoxConstraints(maxHeight: 500),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Language List
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final lang = languages[index];
                      final bool isSelected = lang.code == currentLangCode;
                      return GestureDetector(
                        onTap: () {
                          onSelect(lang);
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${lang.emoji} ${lang.label}",
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
