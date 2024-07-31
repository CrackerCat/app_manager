import 'dart:async';
import 'package:global_repository/global_repository.dart';
import 'package:app_channel/app_channel.dart';
// import 'package:path_provider/path_provider.dart';

enum AppType {
  user,
  system,
}
// 这个类，file_selector会用
class AppUtils {
  static Future<List<AppInfo>> getAllAppInfo({
    AppType appType = AppType.user,
    required AppChannel appChannel,
  }) async {
    bool isSystemApp = false;
    if (appType == AppType.system) {
      isSystemApp = true;
    }
    Stopwatch watch = Stopwatch();
    watch.start();
    AppInfos appInfos = await appChannel.getAppInfosV2(isSystemApp);
    if (appInfos.infos.isEmpty) {
      return [];
    }
    // 排序
    appInfos.infos.sort(
      (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()),
    );
    return appInfos.infos;
  }
}
