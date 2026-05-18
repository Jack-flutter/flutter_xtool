import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

abstract class FlutterXtool {
  PackageInfo? packageInfo;
  BaseDeviceInfo? deviceInfo;
  GetStorage? _storage;

  GetStorage get box {
    return _storage ??= GetStorage();
  }

  /// 初始化
  Future initData() async {
    packageInfo = await PackageInfo.fromPlatform();
    deviceInfo = await DeviceInfoPlugin().deviceInfo;
  }

  /// 手机系统 device_model
  String? get getDeviceModel {
    return Platform.isIOS ? 'ios' : 'android';
  }

  /// 网络状态 network_type
  String? get getNetworkState {
    return 'wifi';
  }

  /// 手机品牌 brand
  String? get getBrand {
    return '';
  }

  /// app包名 bundle_id
  String? get getBundleId {
    return '${packageInfo?.packageName}';
  }

  /// 安卓id App需要有该字段 android_id
  String? get getAndroidId {
    if (Platform.isAndroid) {
      final info = deviceInfo as AndroidDeviceInfo?;
      return info?.id;
    }
    return null;
  }

  /// 厂商类型 manufacturer
  String? get getManufacturer {
    if (Platform.isAndroid) {
      final info = deviceInfo as AndroidDeviceInfo?;
      return info?.manufacturer;
    } else {
      return 'Apple';
    }
  }

  /// 日志id uuid log_id
  String get getLogId {
    return const Uuid().v4();
  }

  /// 系统版本号 os_version
  String get getOsVersion {
    if (Platform.isAndroid) {
      final info = deviceInfo as AndroidDeviceInfo?;
      return info?.version.release ?? '1';
    } else {
      final info = deviceInfo as IosDeviceInfo?;
      return info?.systemVersion ?? '1';
    }
  }

  /// 客户端时间，毫秒数 client_ts
  int get getClientTs {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// 系统语言 system_language
  String get getLanguage {
    return 'en_US';
  }

  /// 应用版本 app_version
  String? get getVersion {
    return packageInfo?.version;
  }

  /// ios的广告原值 idfv
  String? get getIdfv {
    if (Platform.isIOS) {
      final info = deviceInfo as IosDeviceInfo?;
      return info?.identifierForVendor;
    }
    return null;
  }

  /// 供应商名称 operator
  String? get getOperator {
    return 'mnc';
  }

  /// 手机操作系统 os
  String? get getOs {
    return Platform.isIOS ? 'ios' : 'android';
  }

  /// 谷歌的广告ID
  Future<String> getGoogleAdId() async {
    final cacheKey = 'googleAdKey';
    String? id = box.read(cacheKey);
    if (id == null) {
      id = await AdvertisingId.id(true) ?? '';
      box.write(cacheKey, id);
    }
    return id;
  }

  /// 用户唯一id字段 distinct_id
  String? get getDistinctId {
    final cachekey = 'userDistinctKey';
    String? uuid = box.read(cachekey);
    if (uuid == null) {
      uuid = const Uuid().v4();
      box.write(cachekey, uuid);
    }
    return uuid;
  }

  /// 用户唯一id device_id
  Future<UserDevice> obtionDeviceId() async {
    final cacheKey = 'userChainkey';
    bool isNew = false;
    String? deviceID = box.read(cacheKey);
    if (deviceID == null) {
      if (Platform.isAndroid) {
        const androidIdPlugin = AndroidId();
        deviceID = await androidIdPlugin.getId() ?? "";
      } else {
        final storage = const FlutterSecureStorage();
        deviceID = await storage.read(key: cacheKey);
        if (deviceID == null) {
          deviceID = const Uuid().v4();
          storage.write(key: cacheKey, value: deviceID);
          isNew = true;
        }
      }
      box.write(cacheKey, deviceID);
    }
    return UserDevice(id: deviceID, isNew: isNew);
  }
}

class UserDevice {
  final String id;
  final bool isNew;

  UserDevice({required this.id, required this.isNew});
}
