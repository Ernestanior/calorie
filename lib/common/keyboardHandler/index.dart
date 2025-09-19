import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardHandler extends StatefulWidget {
  final Widget child;
  const KeyboardHandler({required this.child, super.key});

  @override
  State<KeyboardHandler> createState() => _KeyboardHandlerState();
}

class _KeyboardHandlerState extends State<KeyboardHandler> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// App 生命周期回调
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App 返回前台，调用原生方法强制隐藏键盘
      _hideKeyboardNative();
    }
  }

  void _hideKeyboardNative() {
    // Flutter 层收起键盘
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    // 调用原生 hide 方法
    const platform = MethodChannel('com.xyvn.vitaai/keyboard');
    platform.invokeMethod('hideKeyboard');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 点击空白隐藏键盘
        FocusManager.instance.primaryFocus?.unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        _hideKeyboardNative();
      },
      child: widget.child,
    );
  }
}
