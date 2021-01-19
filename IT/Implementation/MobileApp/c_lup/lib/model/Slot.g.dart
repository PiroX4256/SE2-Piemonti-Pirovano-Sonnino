// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Slot.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SlotAdapter extends TypeAdapter<Slot> {
  @override
  final int typeId = 4;

  @override
  Slot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Slot(
      id: fields[0] as String,
      startingHour: fields[1] as String,
      weekDay: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Slot obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startingHour)
      ..writeByte(2)
      ..write(obj.weekDay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
