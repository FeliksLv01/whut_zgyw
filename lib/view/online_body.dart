import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:zgyw/util/network.dart';

class OnLineBody extends StatefulWidget {
  const OnLineBody({Key? key}) : super(key: key);

  @override
  State<OnLineBody> createState() => _OnLineBodyState();
}

class _OnLineBodyState extends State<OnLineBody> {
  String time = "";
  String user = "";

  @override
  void initState() {
    super.initState();
    String username = SpUtil.getString("username") ?? "";
    String password = SpUtil.getString("password") ?? "";
    NetworkManager.instance.getUsername().then((value) => setState(() => user = value ?? ""));
    NetworkManager.instance.onLine(username, password).then((timeStr) => setState(() => time = timeStr ?? ""));
    Timer.periodic(const Duration(minutes: 1), (timer) {
      NetworkManager.instance.onLine(username, password).then((timeStr) {
        if (mounted) {
          setState(() {
            time = timeStr ?? "";
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset(
            "asset/books.png",
            height: 96,
            width: 96,
          ),
          const SizedBox(height: 20),
          const Text("每隔1分钟刷新一次", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Text(user, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Text("已经在线: $time", style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
