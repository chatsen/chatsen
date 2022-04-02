// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_appearance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAppearanceAdapter extends TypeAdapter<MessageAppearance> {
  @override
  final int typeId = 6;

  @override
  MessageAppearance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageAppearance()
      ..timestamps = fields[0] as bool
      ..compact = fields[1] as bool
      ..imageEmbeds = fields[2] as bool
      ..channelsEmbeds = fields[3] as bool
      ..fileEmbeds = fields[4] as bool
      ..scale = fields[5] as double;
  }

  @override
  void write(BinaryWriter writer, MessageAppearance obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.timestamps)
      ..writeByte(1)
      ..write(obj.compact)
      ..writeByte(2)
      ..write(obj.imageEmbeds)
      ..writeByte(3)
      ..write(obj.channelsEmbeds)
      ..writeByte(4)
      ..write(obj.fileEmbeds)
      ..writeByte(5)
      ..write(obj.scale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAppearanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
