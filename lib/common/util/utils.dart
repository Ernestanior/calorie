import 'package:flutter/material.dart';

class LanguageOption {
  final String label;
  final String emoji;
  final String code;
  final Locale value;
  LanguageOption({required this.label, required this.emoji, required this.code, required this.value});
}

final List<LanguageOption> languages = [
  LanguageOption(label: "English", emoji: "🇺🇸", code: "en_US",value:const Locale('en', 'US')),
  LanguageOption(label: "中文", emoji: "🇨🇳", code: "zh_CN",value:const Locale('zh', 'CN')),
  // LanguageOption(label: "Español", emoji: "🇪🇸", code: "es"),
  // LanguageOption(label: "Português", emoji: "🇧🇷", code: "pt"),
  // LanguageOption(label: "Français", emoji: "🇫🇷", code: "fr"),
  // LanguageOption(label: "Deutsch", emoji: "🇩🇪", code: "de"),
  // LanguageOption(label: "Italiano", emoji: "🇮🇹", code: "it"),
  // LanguageOption(label: "Română", emoji: "🇷🇴", code: "ro"),
];

LanguageOption getLocaleFromCode(String code) {
  return languages.firstWhere(
    (lang) => lang.code == code,
    orElse: () =>   LanguageOption(label: "English", emoji: "🇺🇸", code: "en_US",value:const Locale('en', 'US')), // 默认英文
  );
}

Map<String, int> inchesToFeetAndInches(int totalInches) {
  int feet = totalInches ~/ 12;
  int inches = totalInches % 12;
  return {'feet': feet, 'inches': inches};
}

int feetAndInchesToInches(int feet, int inches) {
  return feet * 12 + inches;
}