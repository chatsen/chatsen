// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploaded_media.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UploadedMediaAdapter extends TypeAdapter<UploadedMedia> {
  @override
  final int typeId = 5;

  @override
  UploadedMedia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UploadedMedia(
      url: fields[0] as String,
      deletionUrl: fields[1] as String?,
      time: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UploadedMedia obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.deletionUrl)
      ..writeByte(2)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UploadedMediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
