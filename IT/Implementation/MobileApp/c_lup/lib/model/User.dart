import 'package:c_lup/model/Reservation.dart';
import 'package:hive/hive.dart';

part 'User.g.dart';
@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String token;

  @HiveField(1)
  List<Reservation> reservations;

  User({this.token});

  void setReservation(List<Reservation> reservations) {
    this.reservations = reservations;
  }
  void setToken(String token) {
    this.token = token;
  }
}

