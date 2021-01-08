import 'dart:async';
import 'dart:math';

class AuthService {
  Future<bool> login() async {
    return await new Future<bool>.delayed(
        new Duration(seconds: 2), () => new Random().nextBool());
  }
}
