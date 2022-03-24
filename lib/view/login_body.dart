import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

import 'widget/rounded_text_field.dart';

typedef LoginCallBack = void Function(String, String);

class LoginBody extends StatefulWidget {
  final LoginCallBack? onTap;
  const LoginBody({Key? key, this.onTap}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final usernameController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    String username = SpUtil.getString("username") ?? "";
    String password = SpUtil.getString("password") ?? "";
    usernameController.text = username;
    pwdController.text = password;
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
            onPressed: () {
              String username = usernameController.text;
              String password = pwdController.text;
              widget.onTap?.call(username, password);
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
    );
  }
}
