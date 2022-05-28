// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_command.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomCommandAdapter extends TypeAdapter<CustomCommand> {
  @override
  final int typeId = 12;

  @override
  CustomCommand read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomCommand(
      trigger: fields[0] as String,
      command: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CustomCommand obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.trigger)
      ..writeByte(1)
      ..write(obj.command);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomCommandAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
