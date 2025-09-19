把mov转化成mp4
ffmpeg -i aa.mov -vcodec h264 -acodec aac aa.mp4
ffmpeg -i horizontal.mov -vcodec h264 -acodec aac aa.mp4


更换图标
dev_dependencies:
  flutter_launcher_icons: ^0.13.1  # 版本号以pub.dev为准

flutter_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"  # 你的图标路径
  adaptive_icon_background: "#FFFFFF"     # Android 适配图标背景色
  adaptive_icon_foreground: "assets/icon/app_icon.png"

执行命令
flutter pub get
flutter pub run flutter_launcher_icons:main