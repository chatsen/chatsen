import 'dart:convert';
import 'dart:io';

import '/Components/UI/BlurModal.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class UploadModal extends StatelessWidget {
  // if (lowName.endsWith('.png') || lowName.endsWith('.jpg') || lowName.endsWith('.jpeg') || lowName.endsWith('.apng') || lowName.endsWith('.gif') || lowName.endsWith('.webp'))

  static const imgurExtensions = <String>[
    'jpg',
    'jpeg',
    'png',
    'gif',
    'apng',
    'tiff',
    'mp4',
    'mpeg',
    'avi',
    'webm',
    // quicktime
    'mkv', // x-matroska
    'flv', // x-flv
    // x-msvideo
    // x-ms-wmv
  ];

  static const imageExtensions = <String>[
    'jpg',
    'jpeg',
    'png',
    'gif',
    'apng',
    'tiff',
  ];

  static const videoExtensions = <String>[
    'mp4',
    'mpeg',
    'avi',
    'webm',
    // quicktime
    'mkv', // x-matroska
    'flv', // x-flv
    // x-msvideo
    // x-ms-wmv
  ];

  final PlatformFile file;
  final twitch.Channel channel;

  const UploadModal({
    Key? key,
    required this.file,
    required this.channel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lowName = file.name.toLowerCase();
    var extension = lowName.contains('.') ? lowName.split('.').last : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.start,
        // shrinkWrap: true,
        children: [
          Text(
            'You are about to upload ${file.name} and share the link in ${channel.name}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16.0),
          if (imageExtensions.contains(extension)) ...[
            Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
              child: Image.memory(file.bytes!),
            ),
            SizedBox(height: 16.0),
          ],
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (imgurExtensions.contains(extension)) ...[
                  ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      var request = http.MultipartRequest('POST', Uri.parse('https://api.imgur.com/3/upload'));
                      request.files.add(
                        http.MultipartFile.fromBytes(
                          'image',
                          file.bytes!,
                          filename: '${file.name}',
                        ),
                      );
                      var response = await request.send();
                      var responseBody = await response.stream.bytesToString();
                      var responseJson = jsonDecode(responseBody);
                      if (response.statusCode == 200) channel.send(responseJson['data']['link']);
                      print('Upload: $responseBody');
                    },
                    label: Text('imgur'),
                    icon: Icon(Icons.upload),
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.all(16.0)),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))),
                    ),
                  ),
                  SizedBox(width: 12.0),
                ],
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        var request = http.MultipartRequest('POST', Uri.parse('https://catbox.moe/user/api.php'));
                        request.files.add(
                          http.MultipartFile.fromBytes(
                            'fileToUpload',
                            file.bytes!,
                            filename: '${file.name}',
                          ),
                          // file.toMultipartFile(filename: 'file.png'),
                        );
                        request.fields['reqtype'] = 'fileupload';
                        var response = await request.send();
                        var responseBody = await response.stream.bytesToString();
                        if (response.statusCode == 200) channel.send(responseBody);
                        print('Upload: $responseBody');
                      },
                      label: Text('catbox.moe'),
                      icon: Icon(Icons.upload),
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.all(16.0)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                IconButton(
                  onPressed: () async => Navigator.of(context).pop(),
                  // label: Text('Cancel'),
                  icon: Icon(Icons.cancel),
                  // style: ButtonStyle(
                  //   padding: WidgetStateProperty.all(EdgeInsets.all(16.0)),
                  //   shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))),
                  // ),
                ),
                SizedBox(width: 12.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required twitch.Channel channel,
  }) async {
    try {
      var result = await FilePicker.platform.pickFiles(
        type: Platform.isIOS ? FileType.image : FileType.any,
        withData: true,
      );
      var selectedFile = result!.files.first;
      await BlurModal.show(
        context: context,
        child: UploadModal(
          file: selectedFile,
          channel: channel,
        ),
      );
      // ignore: empty_catches
    } catch (e) {
      print(e);
    }
  }
}
