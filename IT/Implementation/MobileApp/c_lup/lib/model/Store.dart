import 'package:hive/hive.dart';

part 'Store.g.dart';

@HiveType(typeId: 2)
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

  Store({this.id, this.name, this.chain, this. address, this.city, this.cap, this.longitude, this.latitude});

}
