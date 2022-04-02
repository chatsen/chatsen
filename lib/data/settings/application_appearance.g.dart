// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_appearance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApplicationAppearanceAdapter extends TypeAdapter<ApplicationAppearance> {
  @override
  final int typeId = 7;

  @override
  ApplicationAppearance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationAppearance()..compact = fields[0] as bool;
  }

  @override
  void write(BinaryWriter writer, ApplicationAppearance obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.compact);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationAppearanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
