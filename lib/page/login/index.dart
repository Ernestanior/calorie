import 'package:flutter/material.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景装饰（叶子图案）
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/leaves_top.png'), // 需要准备叶子图案的图片
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.green,
                    BlendMode.srcOver,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/leaves_bottom.png'), // 需要准备底部叶子图案
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.green,
                    BlendMode.srcOver,
                  ),
                ),
              ),
            ),
          ),
          // 中心内容
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 相机图标
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.green[300],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                // 绿色按钮
                ElevatedButton(
                  onPressed: () {
                    // 按钮点击逻辑
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        '微信登录',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
               ],
            ),
          ),
          // 装饰性星星和叶子（可以根据需要添加更多）
          Positioned(
            bottom: 0,
            left: 20,
            child: Column(
              children: [
                 const Text(
                  '其他方式登录',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                // 手机登录图标
                IconButton(
                  icon: const Icon(Icons.phone, color: Colors.green),
                  onPressed: () {
                    // 手机登录逻辑
                  },
                ),
                const SizedBox(height: 32),
                // 底部隐私条款
                const Text(
                  '我们可能会获取权限《用户使用协议》及《隐私政策》',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              
              ],
            ),
          ),
       ],
      ),
    );
  }
}