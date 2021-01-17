import 'package:hive/hive.dart';

import 'Booking.dart';
import 'Store.dart';

part 'Reservation.g.dart';

@HiveType(typeId: 1)
class Reservation extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  Store store;
  @HiveField(2)
  String status;
  @HiveField(3)
  Booking booking;

  Reservation({this.id, this.store, this.status, this.booking});
}
