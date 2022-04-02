import 'dart:io';

import 'package:hive/hive.dart';

part 'cookie_data.g.dart';

@HiveType(typeId: 4)
class CookieData extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String value;

  @HiveField(2)
  DateTime? expires;

  @HiveField(3)
  int? maxAge;

  @HiveField(4)
  String? domain;

  @HiveField(5)
  String? path;

  @HiveField(6)
  bool secure = false;

  @HiveField(7)
  bool httpOnly = false;

  CookieData({
    required this.name,
    required this.value,
    this.expires,
    this.maxAge,
    this.domain,
    this.path,
    this.secure = false,
    this.httpOnly = false,
  });

  factory CookieData.fromCookie(Cookie cookie) {
    return CookieData(
      name: cookie.name,
      value: cookie.value,
      expires: cookie.expires,
      maxAge: cookie.maxAge,
      domain: cookie.domain,
      path: cookie.path,
      secure: cookie.secure,
      httpOnly: cookie.httpOnly,
    );
  }

  Cookie toCookie() {
    return Cookie(
      name,
      value,
    )
      ..expires = expires
      ..maxAge = maxAge
      ..domain = domain
      ..path = path
      ..secure = secure
      ..httpOnly = httpOnly;
  }
}
