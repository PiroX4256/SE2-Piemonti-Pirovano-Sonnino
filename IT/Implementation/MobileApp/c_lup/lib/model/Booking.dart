import 'package:hive/hive.dart';

import 'Slot.dart';

part 'Booking.g.dart';

///Booking Hive class, it contains the ticket's id, date, [Slot], uuid
///(QR Code), visit duration.
@HiveType(typeId: 3)
class Booking extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String date;
  @HiveField(2)
  Slot slot;
  @HiveField(3)
  String uuid;
  @HiveField(4)
  String visitDuration;

  Booking({this.id, this.date, this.slot, this.uuid, this.visitDuration});
}
