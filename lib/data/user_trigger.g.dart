// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_trigger.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserTriggerAdapter extends TypeAdapter<UserTrigger> {
  @override
  final int typeId = 14;

  @override
  UserTrigger read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserTrigger(
      type: fields[0] as int,
      login: fields[1] as String,
      enableRegex: fields[2] as bool,
      caseSensitive: fields[3] as bool,
      showInMentions: fields[4] as bool,
      sendNotification: fields[5] as bool,
      playSound: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserTrigger obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.login)
      ..writeByte(2)
      ..write(obj.enableRegex)
      ..writeByte(3)
      ..write(obj.caseSensitive)
      ..writeByte(4)
      ..write(obj.showInMentions)
      ..writeByte(5)
      ..write(obj.sendNotification)
      ..writeByte(6)
      ..write(obj.playSound);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTriggerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
