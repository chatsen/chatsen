import 'dart:convert';

import 'package:http/http.dart' as http;

import 'anonfiles_info.dart';

class Anonfiles {
  static Future<AnonfilesFileInfo?> getFileInfo(String id) async {
    final response = await http.get(Uri.parse('https://api.anonfiles.com/v2/file/$id/info'));
    final responseJson = json.decode(utf8.decode(response.bodyBytes));
    if (!(responseJson['status'] ?? false)) return null;
    return AnonfilesFileInfo.fromJson(responseJson['data']['file']);
  }
}
