// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AccountModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountModelAdapter extends TypeAdapter<AccountModel> {
  @override
  final int typeId = 0;

  @override
  AccountModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountModel(
      login: fields[0] as String?,
      token: fields[1] as String?,
      id: fields[2] as int?,
      clientId: fields[3] as String?,
      avatarBytes: fields[4] as Uint8List?,
    )..isActive = fields[5] as bool?;
  }

  @override
  void write(BinaryWriter writer, AccountModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.login)
      ..writeByte(1)
      ..write(obj.token)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.clientId)
      ..writeByte(4)
      ..write(obj.avatarBytes)
      ..writeByte(5)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
