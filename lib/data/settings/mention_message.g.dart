// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mention_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MentionMessageAdapter extends TypeAdapter<MentionMessage> {
  @override
  final int typeId = 10;

  @override
  MentionMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MentionMessage(
      pattern: fields[0] as String,
      notify: fields[1] as bool,
      enableRegex: fields[2] as bool,
      caseSensitive: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MentionMessage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.pattern)
      ..writeByte(1)
      ..write(obj.notify)
      ..writeByte(2)
      ..write(obj.enableRegex)
      ..writeByte(3)
      ..write(obj.caseSensitive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MentionMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
