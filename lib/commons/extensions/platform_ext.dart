import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class PlatformExt {
  Future<double?> getAndroidVersion() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      double? release = double.tryParse(androidInfo.version.release);
      return release;
    } else {
      return null;
    }
  }

  Future<int?> getSdkVersion() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt;
    } else {
      return null;
    }
  }
}
