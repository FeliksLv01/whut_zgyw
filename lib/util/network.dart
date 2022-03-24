import 'dart:developer';

import 'package:http/http.dart' as http;

class NetworkManager {
  NetworkManager._init();

  static final NetworkManager instance = NetworkManager._init();

  static Future<bool> checkNetWork() async {
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse("http://i.whut.edu.cn"));
      return response.statusCode == 200;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
