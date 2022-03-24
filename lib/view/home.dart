import 'dart:io';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sp_util/sp_util.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zgyw/util/network.dart';
import 'package:zgyw/view/login_body.dart';
import 'package:zgyw/view/online_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TrayListener, WindowListener {
  var isLogin = false;

  @override
  void initState() {
    trayManager.addListener(this);
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
    trayManager.setContextMenu([MenuItem(title: "重新登录"), MenuItem(title: "退出")]);
    trayManager.setIcon(Platform.isWindows ? 'asset/books.ico' : 'asset/books.png');
    NetworkManager.instance.checkNetWork().then((isOk) {
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
    } else if (menuItem.title == "重新登录") {
      setState(() {
        isLogin = false;
      });
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            width: 180,
            height: 180,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff5dc8f8)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("中国语文"),
        centerTitle: true,
        backgroundColor: const Color(0xff5dc8f8),
      ),
      body: isLogin
          ? const OnLineBody()
          : LoginBody(
              onTap: (username, password) async {
                if (username.length < 10 || password.isEmpty) {
                  toast("请输入正确的账号密码");
                  return;
                }
                showLoadingDialog(context);
                var flag = await NetworkManager.instance.login(username, password);
                Navigator.pop(context);
                if (!flag) {
                  toast("账号或密码错误");
                } else {
                  SpUtil.putString("username", username);
                  SpUtil.putString("password", password);
                  setState(() {
                    isLogin = true;
                  });
                }
              },
            ),
    );
  }
}
