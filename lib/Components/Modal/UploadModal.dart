import 'package:chatsen/Components/UI/BlurModal.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class UploadModal extends StatelessWidget {
  final FilePickerCross file;
  final twitch.Channel channel;

  const UploadModal({
    Key? key,
    required this.file,
    required this.channel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lowName = file.fileName!.toLowerCase();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You are about to upload ${file.fileName} to https://catbox.moe and share the link in ${channel.name}',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 16.0),
          if (lowName.endsWith('.png') || lowName.endsWith('.jpg') || lowName.endsWith('.jpeg') || lowName.endsWith('.apng') || lowName.endsWith('.gif') || lowName.endsWith('.webp')) ...[
            Center(
              child: Image.memory(
                file.toUint8List(),
                height: 300.0,
              ),
            ),
            SizedBox(height: 16.0),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                var request = http.MultipartRequest('POST', Uri.parse('https://catbox.moe/user/api.php'));
                request.files.add(
                  http.MultipartFile.fromBytes(
                    'fileToUpload',
                    file.toUint8List(),
                    filename: '${file.fileName}',
                  ),
                  // file.toMultipartFile(filename: 'file.png'),
                );
                request.fields['reqtype'] = 'fileupload';
                var response = await request.send();
                var responseBody = await response.stream.bytesToString();
                if (response.statusCode == 200) channel.send(responseBody);
                print('Upload: $responseBody');
              },
              label: Text('Upload ${file.fileName}'),
              icon: Icon(Icons.upload),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(16.0)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () async => Navigator.of(context).pop(),
              label: Text('Cancel'),
              icon: Icon(Icons.cancel),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(16.0)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))),
              ),
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
    var selectedFile = await FilePickerCross.importFromStorage(type: FileTypeCross.any);
    await BlurModal.show(
      context: context,
      child: UploadModal(
        file: selectedFile,
        channel: channel,
      ),
    );
  }
}
