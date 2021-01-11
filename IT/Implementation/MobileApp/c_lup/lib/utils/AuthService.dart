import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:c_lup/model/User.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class AuthService {

  static Future<bool> login({String email, String password}) async {
    var response = await request(email, password);
    if (response.statusCode == 200) {
      var box = Hive.box('properties');
      User user = User()..token = jsonDecode(response.body).token;
      user.save();
      box.add(user);
      return await new Future<bool>.delayed(
          new Duration(seconds: 2), () => true);
    }
    else {
      return false;
    }
  }

  Future<bool> signUp() async {
    return await new Future<bool>.delayed(
        new Duration(seconds: 2), () => new Random().nextBool());
  }

  static Future<http.Response> request(String username, String password)  async{
    return await http.post(
      'http://10.0.2.2:8080/api/auth/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
  }
}
