import 'package:hive/hive.dart';

part 'User.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String token;

  User({this.token});

  void set(String token) {
    this.token = token;
  }
}
