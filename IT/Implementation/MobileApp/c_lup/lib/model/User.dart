import 'package:hive/hive.dart';
@HiveType()
class User extends HiveObject {
  @HiveField(0)
  String token;
}
class UserAdapter extends TypeAdapter<User>{
  @override
  final typeId = 0;

  @override
  User read(BinaryReader reader) {
    return User()..token = reader.read();
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.write(obj.token);
  }
}

