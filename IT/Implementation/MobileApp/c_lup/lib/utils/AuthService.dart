import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:c_lup/model/User.dart';
import 'package:c_lup/utils/Role.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:enum_to_string/enum_to_string.dart';


class AuthService {

  static Future<bool> login({String email, String password}) async {
    var response = await request(email, password, 'login');
    if (response.statusCode == 200) {
      var box = Hive.box<User>('properties');
      User user = box.get('user');
      if (user == null){
        user = new User();
      }
      String token = jsonDecode(response.body)['token'];
      user.setToken(token);
      var response2 = await http.get('http://192.168.1.9:8084/api/auth/me',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + token
          });
      final role = EnumToString.fromString(Role.values, jsonDecode(response2.body)['role']);
      user.setRole(role);
      box.put('user', user);
      return true;
    }
    else {
      return false;
    }
  }

  static Future<bool> signUp({String email, String password, Role role}) async {
    var response = await request(email, password, 'signup', role: role);
    if (response.statusCode == 200) {
      var box = Hive.box('properties');
      User user = User(token: jsonDecode(response.body)['token'], role: role);
      box.put('user', user);
      return true;
    }
    else {
      return false;
    }
    return await new Future<bool>.delayed(
        new Duration(seconds: 2), () => new Random().nextBool());
  }

  static Future<http.Response> request(String username, String password, String type, {Role role})  async{
    String body = jsonEncode(<String, String>{
      'username': username,
      'password': password,
    });
    if(type == 'signup'){
      body = jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'role': role.toString(),
      });
    }
    return await http.post(
      'http://192.168.1.9:8084/api/auth/' + type,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
  }

  static Future<bool> auth(String token) async{
    var response = await http.get('http://192.168.1.9:8084/api/auth/me',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token
    });
    if(response.statusCode == 200){
      return true;
    }
    else return false;
  }

  static Future<bool> codeValidation(String uuid, String token) async{
    var response = await http.get('http://192.168.1.9:8084/api/ticket/validateTicket?uuid=' + uuid,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token
    });
    if(response.statusCode == 200){
      return true;
    }
    else return false;
  }
}
