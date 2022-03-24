import 'dart:io';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sp_util/sp_util.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zgyw/util/network.dart';
import 'package:zgyw/view/login_body.dart';
import 'package:zgyw/view/online_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  var isLogin = false;
  final SystemTray _systemTray = SystemTray();

  @override
  void initState() {
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
    super.initState();
    NetworkManager.instance.checkNetWork().then((isOk) {
      if (!isOk) {
        toast("请连接到校园网或VPN", duration: Toast.LENGTH_LONG);
      }
    });
    initTray();
  }

  Future<void> initTray() async {
    const String _title = '';
    const String _iconPathWin = 'asset/books.ico';
    const String _iconPathOther = 'asset/books.png';
    String _iconPath = Platform.isWindows ? _iconPathWin : _iconPathOther;
    List<MenuItem> menus = [
      MenuItem(label: "重新登录", onClicked: () => setState(() => isLogin = false)),
      MenuItem(label: "退出", onClicked: () => windowManager.destroy())
    ];
    await _systemTray.initSystemTray(title: _title, iconPath: _iconPath);
    await _systemTray.setContextMenu(menus);
    _systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == 'leftMouseDown') {
        windowManager.show();
      } else if (eventName == 'rightMouseDown') {
        _systemTray.popUpContextMenu();
      }
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() {
    super.onWindowClose();
    windowManager.hide();
  }

  @override
  void onWindowFocus() {
    // Make sure to call once.
    setState(() {});
    // do something
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
