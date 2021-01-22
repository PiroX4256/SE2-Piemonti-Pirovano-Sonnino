import 'package:c_lup/model/Reservation.dart';
import 'package:c_lup/model/Store.dart';
import 'package:hive/hive.dart';

part 'User.g.dart';
@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String token;

  @HiveField(1)
  List<Reservation> reservations;

  @HiveField(2)
  String role;

  @HiveField(3)
  List<Store> stores;

  @HiveField(4)
  String storeId;

  User({this.token, this.role, this.reservations, this.stores, this.storeId});

  void setReservation(List<Reservation> reservations) {
    this.reservations = reservations;
  }
  void setToken(String token) {
    this.token = token;
  }
  void setRole(String role) {
    this.role = role;
  }
  void setStores(List<Store> stores){
    this.stores = stores;
  }

  void setStoreId(String storeId){
    this.storeId = storeId;
  }
}

