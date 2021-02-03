import 'dart:async';
import 'dart:convert';

import 'package:c_lup/model/User.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'Globals.dart';

///AuthService class: support class used for REST API authentication.
class AuthService {
  //Request login to Application Server.
  static Future<bool> login({String email, String password}) async {
    var response = await request(email, password, 'login');
    if (response.statusCode == 200) {
      var box = Hive.box<User>('properties');
      User user = box.get('user');
      if (user == null) {
        user = new User();
      }
      String token = jsonDecode(response.body)['token'];
      user.setToken(token);
      var response2 = await http.get('https://' + Globals.ip + '/api/auth/me',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + token
          });
      final role = jsonDecode(response2.body)['role'];
      user.setRole(role);
      box.put('user', user);
      return true;
    } else {
      return false;
    }
  }

  //Request signUp to Application Server.
  static Future<bool> signUp(
      {String email, String password, String role, String storeId}) async {
    var response;
    if (storeId != null) {
      response = await request(email, password, 'signup',
          role: role, storeId: storeId);
    } else {
      response = await request(email, password, 'signup', role: role);
    }
    if (response.statusCode == 200) {
      var box = Hive.box<User>('properties');
      User user =
          new User(token: jsonDecode(response.body)['token'], role: role);
      box.put('user', user);
      return true;
    } else {
      return false;
    }
  }

  //Function used both in login and sign up.
  static Future<http.Response> request(
      String username, String password, String type,
      {String role, String storeId}) async {
    String body = jsonEncode(<String, String>{
      'username': username,
      'password': password,
    });
    if (type == 'signup') {
      if (storeId == null) {
        body = jsonEncode(<String, String>{
          'username': username,
          'password': password,
          'role': role,
        });
      } else {
        body = jsonEncode(<String, String>{
          'username': username,
          'password': password,
          'role': role,
          'storeId': storeId
        });
      }
    }
    return await http.post(
      'https://' + Globals.ip + '/api/auth/' + type,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
  }

  //Check current user token, if valid it returns true otherwise it returns
  // false and the user is redirected to LoginPage. It uses REST API to
  // communicate with Application Server.
  static Future<bool> auth(String token) async {
    var response = await http.get('https://' + Globals.ip + '/api/auth/me',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        });
    if (response.statusCode == 200) {
      return true;
    } else
      return false;
  }

  //Validate qrCode (Attendant only), request is sent to Application Server.
  static Future<bool> codeValidation(String uuid, String token) async {
    var response = await http.get(
        'https://' + Globals.ip + '/api/ticket/validateTicket?uuid=' + uuid,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        });
    if (response.statusCode == 200) {
      return true;
    } else
      return false;
  }

  //Void selected ticket by sending it to the Application Server.
  static void voidTicket(
      String ticketId, String token, bool isAttendant) async {
    await http.get(
        'https://' +
            Globals.ip +
            '/api/ticket/void' +
            (isAttendant == true ? 'User' : '') +
            'Ticket?ticketId=' +
            ticketId,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        });
  }

  //Retrieve ticket by requesting it to the Application Server
  static Future<bool> asap(String storeId, String token) async {
    var response = await http.get(
        'https://' + Globals.ip + '/api/ticket/asap?storeId=' + storeId,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        });
    if (response.statusCode == 200) {
      return true;
    } else
      return false;
  }
}
