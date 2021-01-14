import 'package:hive/hive.dart';

import 'Booking.dart';
import 'Status.dart';
import 'Store.dart';

part 'Reservation.g.dart';

@HiveType(typeId: 1)
class Reservation extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  Store store;
  @HiveField(2)
  Status status;
  @HiveField(3)
  Booking booking;

  Reservation({this.id, this.store, this.status, this.booking});

  void set(String id, Store store, Status status, Booking booking) {
    this.id = id;
    this.store = store;
    this.status = status;
    this.booking = booking;
  }
}
