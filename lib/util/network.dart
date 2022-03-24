import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class NetworkManager {
  NetworkManager._init();

  static final NetworkManager instance = NetworkManager._init();

  static var _cookie = "";

  Future<bool> checkNetWork() async {
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse("http://i.whut.edu.cn"));
      return response.statusCode == 200;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    var res = await http.get(Uri.parse("http://59.69.102.9/zgyw/index.aspx"));
    _cookie = res.headers['set-cookie'] ?? "";
    _cookie = _cookie.split(";").first;
    log(_cookie);

    var document = parse(res.body);
    final viewState = document.getElementById("__VIEWSTATE")?.attributes["value"] ?? "";
    var form = {
      "__VIEWSTATE": viewState,
      r"ctl00$ContentPlaceHolder1$name": username,
      r"ctl00$ContentPlaceHolder1$pwd": password,
      r"ctl00$ContentPlaceHolder1$login": "登入"
    };
    res = await http.post(Uri.parse("http://59.69.102.9/zgyw/index.aspx"), headers: {"Cookie": _cookie}, body: form);
    document = parse(res.body);
    if (document.getElementById("ctl00_ContentPlaceHolder1_lblTip")?.text == null) {
      log("登录成功");
      return true;
    }
    log("用户名或密码错误");
    return false;
  }

  Future<String?> onLine(String username, String password) async {
    var url = "http://59.69.102.9/zgyw/study/LearningContent.aspx?type=3&id=19&learningid=2939";
    await http.get(Uri.parse(url), headers: {"Cookie": _cookie});
    var res = await http.get(Uri.parse("http://59.69.102.9/zgyw/index.aspx"), headers: {"Cookie": _cookie});
    if (res.statusCode != 200) {
      login(username, password);
      return null;
    }
    var document = parse(res.body);
    var timeNode = document.getElementById("ctl00_ContentPlaceHolder1_lblonlineTime");
    if (timeNode != null) {
      log(timeNode.text);
    }
    return timeNode?.text;
  }

  Future<String?> getUsername() async {
    var res = await http.get(Uri.parse("http://59.69.102.9/zgyw/index.aspx"), headers: {"Cookie": _cookie});
    var document = parse(res.body);
    var nameNode = document.getElementById("ctl00_ContentPlaceHolder1_lblrealname");
    final name = nameNode?.children.first.text;
    return name;
  }
}
