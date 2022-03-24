import 'dart:io';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zgyw/util/network.dart';

import 'rounded_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TrayListener, WindowListener {
  final usernameController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  void initState() {
    trayManager.addListener(this);
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
    trayManager.setContextMenu([MenuItem(title: "退出")]);
    trayManager.setIcon(Platform.isWindows ? 'asset/books.ico' : 'asset/books.png');
    NetworkManager.checkNetWork().then((isOk) {
      if (!isOk) {
        toast("请连接到校园网或VPN", duration: Toast.LENGTH_LONG);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() {
    // TODO: implement onWindowClose
    super.onWindowClose();
    windowManager.hide();
  }

  @override
  void onTrayIconMouseDown() {
    windowManager.show();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.title == "退出") {
      windowManager.destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("中国语文"),
        centerTitle: true,
        backgroundColor: const Color(0xff5dc8f8),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              "asset/books.png",
              height: 96,
              width: 96,
            ),
            const SizedBox(height: 30),
            RoundedInputField(
              icon: Icons.person,
              hintText: '学号',
              controller: usernameController,
            ),
            RoundedInputField(
              icon: Icons.lock,
              hintText: '密码',
              obscureText: true,
              controller: pwdController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                NetworkManager.checkNetWork();
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff5dc8f8),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: const Text('登录', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
