// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitch_account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TwitchAccountAdapter extends TypeAdapter<TwitchAccount> {
  @override
  final int typeId = 1;

  @override
  TwitchAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TwitchAccount(
      tokenData: fields[0] as TokenData,
      userData: fields[1] as UserData?,
      cookies: (fields[2] as List?)?.cast<CookieData>(),
    );
  }

  @override
  void write(BinaryWriter writer, TwitchAccount obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.tokenData)
      ..writeByte(1)
      ..write(obj.userData)
      ..writeByte(2)
      ..write(obj.cookies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwitchAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
