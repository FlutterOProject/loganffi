import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:logan_ffi/loganffi/logan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion ='';

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              Container(
                margin: EdgeInsets.all(10),
                child: Button(
                  () async {
                    String cache = await getCachePath();
                    String loger = await getLoggerPath();

                    print('init cache：${cache}');
                    print('init loger：${loger}');

                    Clogan.init(cache, loger, 10 *1024 * 1024, 3, "0123456789067890", "0123456789067890");
                    Clogan.open('chengleilogan.txt');
                    Clogan.write(2, 'chenglei',
                        DateTime.now().millisecondsSinceEpoch, 'main', 1, true);
                    Clogan.flush();
                  },
                  title: 'call logan write a log',
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Button(
                  () async {
                    for (int i = 0; i < 900000; i++) {
                      if(i%2==0){
                        Clogan.log(
                            1,
                            'loger info --===' +
                                DateTime.now().millisecondsSinceEpoch.toString());
                      }else{
                        Clogan.log(
                            2,
                            '222:::' +
                                DateTime.now().millisecondsSinceEpoch.toString());
                      }

                    }
                    Clogan.flush();
                    print('init flush');
                  },
                  title: '写入 10000 跳数据',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String rootFolderName = "FanbookLogger"; // 日志根目录
  String cacheName = "LoggerCache"; // 日志根目录

  // 获取路径
  Future<String> get _localPath async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getTemporaryDirectory();
    return directory?.path ?? "";
  }

  // 获取日志根目录
  Future<String> getLoggerPath() async {
    final String path = await _localPath;
    return "$path/$rootFolderName";
  }

  // 获取缓存路径
  Future<String> getCachePath() async {
    final String path = await _localPath;
    return "$path/$cacheName";
  }
}

class Button extends StatelessWidget {
  final String title;
  final Color titleColor;
  final double width, height;
  final GestureTapCallback onPress;

  Button(this.onPress,
      {this.title = "",
      this.titleColor = Colors.red,
      this.width = 200,
      this.height = 40});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: InkWell(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      onTap: onPress,
      child: Ink(
        padding: EdgeInsets.all(5),
        width: (width == null || width == 0) ? 120 : width,
        height: (height == null || height == 0) ? 44 : height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).primaryColor),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: this.titleColor),
          ),
        ),
      ),
    ));
  }
}