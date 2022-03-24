import 'dart:io';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sp_util/sp_util.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zgyw/view/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    // 隐藏窗口标题栏
    if (Platform.isMacOS) await windowManager.setTitleBarStyle("hidden");
    await windowManager.setSize(const Size(800, 600));
    await windowManager.setMinimumSize(const Size(600, 500));
    await windowManager.center();
    await windowManager.show();
    if (Platform.isMacOS) await windowManager.setSkipTaskbar(false);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      toastTheme: ToastThemeData(textColor: Colors.white, background: Colors.black.withOpacity(0.54)),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
