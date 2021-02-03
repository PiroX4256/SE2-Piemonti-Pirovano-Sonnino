import 'package:hive/hive.dart';

part 'Slot.g.dart';

///Slot Hive class, it contains the slot's id, starting hour and day of the
///week.
@HiveType(typeId: 4)
class Slot extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String startingHour;
  @HiveField(2)
  String weekDay;

  Slot({this.id, this.startingHour, this.weekDay});
}
