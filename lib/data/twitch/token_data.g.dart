// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TokenDataAdapter extends TypeAdapter<TokenData> {
  @override
  final int typeId = 2;

  @override
  TokenData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TokenData(
      clientId: fields[0] as String?,
      login: fields[1] as String,
      scopes: (fields[2] as List).cast<String>(),
      userId: fields[3] as String?,
      expiresAt: fields[4] as DateTime?,
      accessToken: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TokenData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.clientId)
      ..writeByte(1)
      ..write(obj.login)
      ..writeByte(2)
      ..write(obj.scopes)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.expiresAt)
      ..writeByte(5)
      ..write(obj.accessToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
