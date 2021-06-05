import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'AccountModel.g.dart';

/// The [AccountModel] is a class that holds our data for the accounts.
@HiveType(typeId: 0)
class AccountModel extends HiveObject {
  @HiveField(0)
  String? login;

  @HiveField(1)
  String? token;

  @HiveField(2)
  int? id;

  @HiveField(3)
  String? clientId;

  @HiveField(4)
  Uint8List? avatarBytes;

  @HiveField(5)
  bool? isActive = false;

  AccountModel({
    this.login,
    this.token,
    this.id,
    this.clientId,
    this.avatarBytes,
  });
}
