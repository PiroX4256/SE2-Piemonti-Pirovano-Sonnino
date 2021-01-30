// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Store.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreAdapter extends TypeAdapter<Store> {
  @override
  final int typeId = 2;

  @override
  Store read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Store(
      id: fields[0] as String,
      name: fields[1] as String,
      chain: fields[2] as String,
      address: fields[3] as String,
      city: fields[4] as String,
      cap: fields[5] as String,
      longitude: fields[6] as String,
      latitude: fields[7] as String,
      slots: (fields[8] as List)?.cast<Slot>(),
    );
  }

  @override
  void write(BinaryWriter writer, Store obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.chain)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.city)
      ..writeByte(5)
      ..write(obj.cap)
      ..writeByte(6)
      ..write(obj.longitude)
      ..writeByte(7)
      ..write(obj.latitude)
      ..writeByte(8)
      ..write(obj.slots);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
