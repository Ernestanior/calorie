// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:calorie/components/buttonX/index.dart';
import 'package:calorie/components/buttonX/planButton.dart';
import 'package:calorie/network/api.dart';
import 'package:calorie/store/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SurveyAnalysis extends StatefulWidget {

  const SurveyAnalysis({
    super.key,

  });
  @override
  State<SurveyAnalysis> createState() => _SurveyAnalysisState();
}

class _SurveyAnalysisState extends State<SurveyAnalysis> with TickerProviderStateMixin {
  //顶部三个图标跳动
  late AnimationController _LottieController1;
  late AnimationController _LottieController2;
  late AnimationController _LottieController3;

  // 流
  StreamSubscription? _subscription;
  late http.Client httpClient;
  //进度条
  double progress = 0.0;
  bool isFastForward = false;
  bool isDisposed = false;
  //显示框
  // String fullText ="接下来确定三大营养素的比例。通常减脂建议蛋白质摄入较高，脂肪适量，碳水减少。比如蛋白质2g/kg体重，脂肪0.8g/kg，剩下的热量给碳水。不过可能有不同建议，比如蛋白质1.6-2.2g/kg之间。这里取蛋白质2g/kg，即60kg*2=120g蛋白质，提供120*4=480kcal。脂肪部分假设摄入量是0.8g/kg，60*0.8=48g，提供48*9=432kcal。剩下的热量由碳水提供：总热量1441 - (480+432)=529kcal，529/4≈132.25g碳水。但需要确认这样分配是否符合常规。或者另一种方法是用比例，比如蛋白质25%、脂肪25%、碳水50%。或者根据用户的健身目标调整，但用户没有说明，所以不过可能更准确的是根据热量分配。例如，蛋白质占总热量的20-30%，脂肪20-30%，碳水40-60%。但根据减脂情况，可能提高蛋白质。比如蛋白质30%，脂肪25%，碳水45%。假设蛋白质30%：1441*0.3=432.3kcal →432.3/4=108g。脂肪25%：1441*0.25=360.25kcal →360.25/9≈40g。碳水45%：1441*0.45=648.45kcal →648.45/4≈162g。这样分配的话，数字会不同。但用户可能需要更高的蛋白质，所以可能采用每公斤体重来计算更合理。或者，根据不同的指导方针，比如对于减脂，蛋白质建议1.6-2.2g/kg，这里选2g，所以60kg*2=120g，热量480kcal。脂肪可以设为总热量的25%，即1441*0.25=360.25kcal →40g。剩下的热量是1441 -480 -360=601kcal，由碳水提供，601/4≈150.25g。这可能更合理。所以最终的数据可能是：蛋白质120g，脂肪40g，碳水150g，热量1441kcal。不过需要检查计算是否正确。总热量：120*4=480，40*9=360，150*4=600，总和480+360+60嗯我现在需要帮用户计算每日所需的卡路里以及三大营养素的摄入量。用户给出的数据是：体重60kg，目标体重59kg，每周增减0.4kg，性别男，年";
  String fullText="";
  String displayedText = "";
  String queueText = ""; // **存放追加的文本**
  int currentIndex = 0;
  bool isTyping = false; // **标记当前是否正在打字**
  Timer? timer;
  bool buttonState=false;
  String buttonTitle='CREATING_PLAN'.tr;
  ScrollController _scrollController = ScrollController();


  Future<void> _fetchSSEStream(data) async {
    httpClient = http.Client();
    var request = http.Request("PUT", Uri.parse('${baseUrl}/deepseek/create-reasoner'));

    request.headers.addAll({
      "Content-Type": "application/json",
    });
    request.body = jsonEncode(data);
    // print('chat $data');
    var response = await httpClient.send(request);
    // 监听 SSE 数据流
    _subscription = response.stream.transform(utf8.decoder).listen((dynamic event) {
      // if (event['status']==404) {
      //   print(event['error']);
      // }
      for (var line in event.split("\n")) {
        if (line.startsWith("data: [DONE]")) {
          return;
        }
        if (line.startsWith("data: ")) {
          var jsonData = line.substring(6).trim();
          if (jsonData.isNotEmpty) {
            try {
              var decoded = jsonDecode(jsonData);
              if (decoded.containsKey("choices")) {
                var content = decoded["choices"][0]["delta"]["reasoning_content"];
                if (content != null) {
                  addNewText(content);
                }
              }
            } catch (e) {
              print('event $event');
            }
          }
        }
      }
    }, onDone: () {
      print("SSE 连接关闭");
      if (!isTyping && queueText.isNotEmpty) {
        fullText = queueText+'\n'+"PERSONALIZED_PLAN_IS_READY".tr;
        queueText = "";
        startTyping();
      }
      _jumpTo100();
      
    }, onError: (error) {
      print("SSE 发生错误: $error");
    });
  }

    Future<void> reportGenerate (data) async {
      final res = await aiAnalysisResult(data);
      Timer(const Duration(seconds: 3), () {
        setState(() {
          buttonState=true;
        });
      });
    }

  
  void startTyping() async{
    if (isTyping) return; // **防止重复调用**
    isTyping = true;
    timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      if (currentIndex < fullText.length) {
        setState(() {
          displayedText += fullText[currentIndex];
          currentIndex++;
        });
        // **自动滚动到底部**
        _autoScrollToBottom();
      } else {
        timer.cancel();
        isTyping = false;
        currentIndex = 0;

        // **如果有待显示的文本，开始新的打字**
        if (queueText.isNotEmpty) {
          fullText = queueText; // 把队列文本设为当前文本
          queueText = ""; // 清空队列
          startTyping(); // 继续打字
        }
      }
    });

    
  }

  void addNewText(content) {
    if (isTyping) {
      queueText += "$content"; // **先存入队列，等待打字完成**
    } else {
      displayedText += "\n"; // **直接换行**
      startTyping();
    }
  }

  void _autoScrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
  @override
  void initState() {
    super.initState();
    _LottieController1 = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _LottieController2 = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _LottieController3 = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    startAnimations();
    _startSlowProgress();

    startTyping();
    // 获取传递的数据
    final Map<String, dynamic> data = Get.arguments ?? {};
    _fetchSSEStream(data);
    reportGenerate(data);
  }

  @override
  void dispose() {
    isDisposed=true;
    _subscription?.cancel();
    _subscription = null;
    httpClient.close();//强制关闭http请求连接
    _LottieController1.dispose();
    _LottieController2.dispose();
    _LottieController3.dispose();
    timer?.cancel(); // 取消定时器
    super.dispose();
  }

   void startAnimations() async {
    _LottieController1.repeat();
    await Future.delayed(const Duration(milliseconds: 400));
    _LottieController2.repeat();
    await Future.delayed(const Duration(milliseconds: 400));
    _LottieController3.repeat();
  }

   // **初始缓慢前进到 80%**
  void _startSlowProgress() async {
    while (progress < 0.8 && !isFastForward) {
      await Future.delayed(Duration(milliseconds: 200));
      if (isDisposed) return;
      setState(() {
        progress += 0.02; // 让进度慢慢增加
        if (progress > 0.8) progress = 0.8;
      });
    }
  }

    // **点击按钮后：立即跳到 100%**
  void _jumpTo100() async{
    setState(() {
      isFastForward = true;
      progress = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        padding:const EdgeInsets.symmetric(horizontal: 5),        
        child: Column(
        children: [
          const SizedBox(height: 68,),
          Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/image/rice.json', controller: _LottieController1, width: 50),
                    const SizedBox(width: 20,),
                    Lottie.asset('assets/image/beef.json', controller: _LottieController2, width: 50),
                    const SizedBox(width: 20,),
                    Lottie.asset('assets/image/egg.json', controller: _LottieController3, width: 50),
                  ],
            ),
          ),
          const SizedBox(height: 20,),
            // **进度条**
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: progress),
              duration: Duration(milliseconds: progress == 1.0 ? 500 : 60000), // 80% 慢速，100% 快速
              builder: (context, double value, child) {
                return SizedBox(
                  width: 300,
                  child: LinearProgressIndicator(
                      value: value,
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.grey[300],
                      color: const Color.fromARGB(255, 162, 208, 255),
                    ),
                );
              },
            ),
            const SizedBox(height: 30,),
            Container(
              padding: const EdgeInsets.all(10),
              height: 500,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 221, 221, 221)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DEEP_ANALYSIS".tr,
                      style: TextStyle(fontSize: 14, height: 1.5, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      displayedText,
                      style: const TextStyle(fontSize: 14, height: 1.5, color: Color.fromARGB(255, 103, 103, 103)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: buttonState,
              child: PlanButton(onSubmit: () async{
                _subscription?.cancel();
                _subscription=null;
                _jumpTo100();
                await UserInfo().getUserInfo();
                // Navigator.pushNamedAndRemoveUntil(
                //   context,
                //   '/surveyResult',      // 要跳转的目标页面名称
                //   (route) => false,  // 清除所有旧路由
                // );
                Navigator.pushNamed(context,'/surveyResult');
              }))
          ],
        ),
      )]))
  
    );
  }
}

    