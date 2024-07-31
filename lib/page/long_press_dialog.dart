import 'package:app_channel/app_channel.dart';
import 'package:app_manager/global/global.dart';
import 'package:app_manager/controller/app_manager_controller.dart';
import 'package:app_manager/controller/check_controller.dart';
import 'package:app_manager/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LongPress extends StatefulWidget {
  const LongPress({Key? key}) : super(key: key);

  @override
  State createState() => _LongPressState();
}

class _LongPressState extends State<LongPress> {
  CheckController controller = Get.find();
  Widget item(String title, void Function() onTap) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 52.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.fontColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Text(
                '选择了${controller.check.length}个应用',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            item('清除数据', () {}),
            item('卸载', () {}),
            item('冻结', () async {
              Get.back();
              AppManagerController managerController = Get.find();
              for (AppInfo? entity in controller.check) {
                bool success = await Global().appChannel!.freezeApp(entity!.package);
                if (success) {
                  entity.enabled = false;
                  managerController.update();
                }
              }
              controller.clearCheck();
            }),
            item('解冻', () async {
              Get.back();
              AppManagerController managerController = Get.find();
              for (AppInfo? entity in controller.check) {
                bool success = await Global().appChannel!.unFreezeApp(entity!.package);
                if (success) {
                  entity.enabled = true;
                  managerController.update();
                }
              }
              controller.clearCheck();
            }),
            item('打开', () {}),
            item('导出', () {}),
          ],
        ),
      ),
    );
  }
}
