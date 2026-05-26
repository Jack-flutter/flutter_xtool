import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:android_id/android_id.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class FlutterXtool {
  UserDevice? _userDevice;

  /// 保存数据
  void saveCacheData(String key, String value);

  /// 获取数据
  String getCacheData(String key);

  /// 应用版本 app_version
  String? get getVersion;

  /// ios的广告原值 idfv
  String? get getIdfv;

  /// app包名 bundle_id
  String? get getBundleId;

  /// 安卓id App需要有该字段 android_id
  String? get getAndroidId;

  /// 厂商类型 manufacturer
  String? get getManufacturer;

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

  /// 日志id uuid log_id
  String get getLogId {
    return const Uuid().v4();
  }

  /// 系统版本号 os_version
  String get getOsVersion;

  /// 客户端时间，毫秒数 client_ts
  int get getClientTs {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// 系统语言 system_language
  String get getLanguage {
    return 'en_US';
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
    String id = getCacheData(cacheKey);
    if (id.isEmpty) {
      id = await AdvertisingId.id(true) ?? '';
      saveCacheData(cacheKey, id);
    }
    return id;
  }

  /// 用户唯一id字段 distinct_id
  String? get getDistinctId {
    final cachekey = 'userDistinctKey';
    String uuid = getCacheData(cachekey);
    if (uuid.isEmpty) {
      uuid = const Uuid().v4();
      saveCacheData(cachekey, uuid);
    }
    return uuid;
  }

  /// 用户唯一id device_id
  Future<UserDevice> getDeviceId() async {
    if (_userDevice != null) return _userDevice!;
    final cacheKey = 'userChainKey';
    bool isNew = false;
    String deviceID = getCacheData(cacheKey);
    if (deviceID.isEmpty) {
      if (Platform.isAndroid) {
        const androidIdPlugin = AndroidId();
        deviceID = await androidIdPlugin.getId() ?? "";
        isNew = true;
      } else {
        final storage = const FlutterSecureStorage();
        deviceID = await storage.read(key: cacheKey) ?? '';
        if (deviceID.isEmpty) {
          deviceID = const Uuid().v4();
          storage.write(key: cacheKey, value: deviceID);
          isNew = true;
        }
      }
      saveCacheData(cacheKey, deviceID);
    }
    _userDevice = UserDevice(id: deviceID, isNew: isNew);
    return _userDevice!;
  }
}

class UserDevice {
  final String id;
  final bool isNew;

  UserDevice({required this.id, required this.isNew});
}
