// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlockedMessageAdapter extends TypeAdapter<BlockedMessage> {
  @override
  final int typeId = 8;

  @override
  BlockedMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlockedMessage(
      pattern: fields[0] as String,
      regex: fields[1] as bool,
      caseSensitive: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BlockedMessage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.pattern)
      ..writeByte(1)
      ..write(obj.regex)
      ..writeByte(2)
      ..write(obj.caseSensitive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockedMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
