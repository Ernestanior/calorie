// import 'dart:html';
import 'package:flutter/material.dart';


class Privacy extends StatefulWidget {
  const Privacy({super.key});
  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.bold,);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('隐私协议',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child:  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('隐私政策',style: titleStyle,textAlign: TextAlign.left,),
              Text('本隐私政策描述了我们在您使用服务时收集、使用和披露您信息的政策和程序，并告知您隐私权利及法律对您的保护。'),
              Text('我们使用您的个人数据以提供和改进服务。通过使用服务，您同意按照本隐私政策收集和使用信息。'),
              Text('以下是我们的特别提示，请您重点关注：'),
              Text('（1）为了保障产品的正常运行，实现上传图片、拍摄照片以及其他功能，我们会收集你的部分必要信息；'),
              Text('（2）在你进行上传资料、注册认证的服务时，基于法律要求或实现功能所必需，我们可能会收集手机号、图文、音视频文件的个人信息。你有权拒绝向我们提供这些信息，或者撤回你对这些信息的授权同意。请你了解，拒绝或撤回授权同意，将导致你无法使用相关的特定功能，但不影响你使用“轻卡APP”的其他功能；'),
              Text('（3）我们会将在境内运营过程中收集和产生的你的个人信息存储于中华人民共和国境内，不会将上述信息传输至境外。我们仅会在为提供“轻卡APP”软件及相关服务之目的所必需的期间内保留你的个人信息；'),
              Text('（4）我们不会向第三方共享、提供、转让或者从第三方获取你的个人信息，除非经过你的同意；'),
              Text('（5）我们将努力采取合理的安全措施来保护你的个人信息。特别的，我们将采用行业内通行的方式及尽最大的商业努力来保护你个人敏感信息的安全。'),
              Text('（6）轻卡APP会根据您的基础信息和已记录的饮食，为您计算每餐热量；'),
              Text('（7）你访问、更正、删除个人信息与撤回同意授权的方式，以及投诉举报的方式。'),
              Text('如你未明示同意本隐私政策并开始使用，我们将不会收集您的个人信息，这将导致我们无法为您提供完整的产品和服务。如您点击“同意”并确认提交，即视为您同意本隐私政策,并同意我们将按照本政策来收集、使用、存储和共享您的相关信息。'),
              Text('我们非常重视用户个人信息的保护，并且将以勤勉和审慎的义务对待这些信息。你在下载、安装、开启、浏览、注册、登录、使用（以下统称“使用”）“轻卡APP”软件及相关服务时，我们将按照本《隐私政策》收集、保存、使用、披露及保护你的个人信息。我们希望通过本《隐私政策》向你介绍我们对你个人信息的处理方式，因此我们建议你认真完整地阅读本《隐私政策》的所有条款。'),   
            ],
          ),
        ) 
      ) 
    );
  }
}

