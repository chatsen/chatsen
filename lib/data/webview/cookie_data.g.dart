// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cookie_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CookieDataAdapter extends TypeAdapter<CookieData> {
  @override
  final int typeId = 4;

  @override
  CookieData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CookieData(
      name: fields[0] as String,
      value: fields[1] as String,
      expires: fields[2] as DateTime?,
      maxAge: fields[3] as int?,
      domain: fields[4] as String?,
      path: fields[5] as String?,
      secure: fields[6] as bool,
      httpOnly: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CookieData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.expires)
      ..writeByte(3)
      ..write(obj.maxAge)
      ..writeByte(4)
      ..write(obj.domain)
      ..writeByte(5)
      ..write(obj.path)
      ..writeByte(6)
      ..write(obj.secure)
      ..writeByte(7)
      ..write(obj.httpOnly);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CookieDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
