import 'package:hive/hive.dart';

import 'Slot.dart';

part 'Store.g.dart';

@HiveType(typeId: 2)
// ignore: must_be_immutable
class Store extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String chain;
  @HiveField(3)
  String address;
  @HiveField(4)
  String city;
  @HiveField(5)
  String cap;
  @HiveField(6)
  String longitude;
  @HiveField(7)
  String latitude;
  @HiveField(8)
  List<Slot> slots;

  Store({this.id, this.name, this.chain, this.address, this.city, this.cap, this.longitude, this.latitude, this.slots});

}
