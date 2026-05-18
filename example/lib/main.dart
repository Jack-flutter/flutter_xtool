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
    utils.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: TextButton(
            onPressed: () {
              log(utils.packageInfo?.version ?? '--');
            },
            child: const Text('点击'),
          ),
        ),
      ),
    );
  }
}

class Utils extends FlutterXtool {}
