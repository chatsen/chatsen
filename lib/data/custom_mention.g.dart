// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_mention.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomMentionAdapter extends TypeAdapter<CustomMention> {
  @override
  final int typeId = 13;

  @override
  CustomMention read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomMention(
      pattern: fields[0] as String,
      enableRegex: fields[1] as bool,
      caseSensitive: fields[2] as bool,
      showInMentions: fields[3] as bool,
      sendNotification: fields[4] as bool,
      playSound: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CustomMention obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.pattern)
      ..writeByte(1)
      ..write(obj.enableRegex)
      ..writeByte(2)
      ..write(obj.caseSensitive)
      ..writeByte(3)
      ..write(obj.showInMentions)
      ..writeByte(4)
      ..write(obj.sendNotification)
      ..writeByte(5)
      ..write(obj.playSound);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomMentionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
