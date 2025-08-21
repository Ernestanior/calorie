import 'package:calorie/common/util/utils.dart';
import 'package:calorie/main.dart';
import 'package:calorie/network/api.dart';
import 'package:calorie/store/store.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount>
    with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool reason1 = false;
  bool reason2 = false;
  bool reason3 = false;
  String remark = '';
  @override
  Widget build(BuildContext context) {
    onSubmit() async {
      // dynamic res = await detectionDelete();
      // if (res == '') {
      //   Controller.c.user({});
      //   Get.back();
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (BuildContext context) {
      //     return const BottomNavScreen();
      //   }), (route) => false);
      // }
      await userDelete();
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      var res = await login(iosInfo.identifierForVendor as String,initData);
      Controller.c.user(res);
      Get.updateLocale(getLocaleFromCode(res['lang']).value );
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',      // 要跳转的目标页面名称
        (route) => false,  // 清除所有旧路由
      );
    }

    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      height: 220,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(
              Icons.warning,
              color: Colors.red,
            ),
            Container(
              width: 5,
            ),
            Text(
              'DELETE_CONFIRMATION'.tr,
              style: const TextStyle(
                  color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ]),
          Container(
            height: 10,
          ),
          Text(
              'DELETE_CONFIRMATION_TIP'.tr,
              style: const TextStyle(
                  color: Colors.red, fontSize: 12, ),
            ),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.white),
                    foregroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 137, 137, 137)),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
                  child: Text('CANCEL'.tr,style: const TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
              Container(
                width: 20,
              ),
              Expanded(
                  child: ElevatedButton(
                onPressed: onSubmit,
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.red),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
                child: Text('CONFIRM'.tr,style: const TextStyle(fontWeight: FontWeight.bold),),
              ))
            ],
          )
        ],
      ),
    );
  }
}
