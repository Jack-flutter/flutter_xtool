import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_xtool/flutter_xtool.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Utils utils = Utils();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: TextButton(
            onPressed: () async {
              final data = await utils.getDeviceId();
              log(data.id);
            },
            child: const Text('点击'),
          ),
        ),
      ),
    );
  }
}

class Utils extends FlutterXtool {
  @override
  String getCacheData(String key) {
    // TODO: implement getCacheData
    return '';
  }

  @override
  void saveCacheData(String key, String value) {
    // TODO: implement saveCacheData
  }

  @override
  // TODO: implement getAndroidId
  String? get getAndroidId => throw UnimplementedError();

  @override
  // TODO: implement getBundleId
  String? get getBundleId => throw UnimplementedError();

  @override
  // TODO: implement getIdfv
  String? get getIdfv => throw UnimplementedError();

  @override
  // TODO: implement getManufacturer
  String? get getManufacturer => throw UnimplementedError();

  @override
  // TODO: implement getOsVersion
  String get getOsVersion => throw UnimplementedError();

  @override
  // TODO: implement getVersion
  String? get getVersion => throw UnimplementedError();
}
