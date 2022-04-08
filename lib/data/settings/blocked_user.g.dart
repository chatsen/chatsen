// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlockedUserAdapter extends TypeAdapter<BlockedUser> {
  @override
  final int typeId = 9;

  @override
  BlockedUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlockedUser(
      login: fields[0] as String?,
      id: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BlockedUser obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.login)
      ..writeByte(1)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockedUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
