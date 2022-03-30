import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;

import 'package:chatsen/data/filesharing/uploaded_media.dart';

class Catbox {
  static Future<UploadedMedia> uploadFile(String filename, Uint8List bytes) async {
    final request = http.MultipartRequest('POST', Uri.parse('https://catbox.moe/user/api.php'));
    request.files.add(
      http.MultipartFile.fromBytes(
        'fileToUpload',
        bytes,
        filename: filename,
      ),
    );
    request.fields['reqtype'] = 'fileupload';

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    return UploadedMedia(
      time: DateTime.now(),
      url: responseBody,
    );
  }
}
