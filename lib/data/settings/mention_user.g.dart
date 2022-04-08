// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mention_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MentionUserAdapter extends TypeAdapter<MentionUser> {
  @override
  final int typeId = 11;

  @override
  MentionUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MentionUser(
      login: fields[0] as String?,
      id: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MentionUser obj) {
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
      other is MentionUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
