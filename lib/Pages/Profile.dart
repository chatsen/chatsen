import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/MVP/Models/AccountModel.dart';
import '/MVP/Presenters/AccountPresenter.dart';
import 'package:http/http.dart' as http;

/// The [ProfilePage] is a page that contains the information about the current logged in user. It allows you to copy your information if you wish to or to upload a new avatar on demand.
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void changeAvatar(AccountModel? model) async {
    var result = await (FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png'],
      withData: true,
    ) as FutureOr<FilePickerResult>);

    if (result.files.isEmpty) return;

    model!.avatarBytes = result.files.first.bytes;
    model.save();

    var uploadUrlRequest = await http.post(
      Uri.parse('https://api.twitch.tv/kraken/users/${model.id}/upload_image?client_id=${model.clientId}&api_version=5&image_type=profile_image&format=png'),
      headers: {
        'dnt': '1',
        'origin': 'https://www.twitch.tv',
        'referer': 'https://www.twitch.tv/',
        'Authorization': 'OAuth ${model.token}',
      },
    );

    var uploadUrlResult = jsonDecode(utf8.decode(uploadUrlRequest.bodyBytes));
    if (uploadUrlResult['upload_url'] == null) return;

    var fileRequest = http.Request(
      'PUT',
      Uri.parse(uploadUrlResult['upload_url']),
    )..bodyBytes = result.files.first.bytes!;
    fileRequest.headers['Content-Type'] = 'image/png';

    await fileRequest.send();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: FutureBuilder<AccountModel?>(
          future: AccountPresenter.findCurrentAccount(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  if (snapshot.data!.avatarBytes != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Ink.image(
                            image: MemoryImage(snapshot.data!.avatarBytes!),
                            fit: BoxFit.fill,
                            width: 150,
                            height: 150,
                            child: InkWell(
                              onTap: () async => changeAvatar(snapshot.data),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (snapshot.data!.avatarBytes == null && snapshot.data!.token != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: Icon(Icons.upload_file),
                        onPressed: () async => changeAvatar(snapshot.data),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data!.login!,
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: TextEditingController(text: snapshot.data!.token),
                      decoration: InputDecoration(
                        labelText: 'Token',
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () async => await Clipboard.setData(ClipboardData(text: snapshot.data!.token)),
                        ),
                      ),
                      readOnly: true,
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: TextEditingController(text: snapshot.data!.clientId),
                      decoration: InputDecoration(
                        labelText: 'Client ID',
                        filled: true,
                      ),
                      readOnly: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: TextEditingController(text: snapshot.data!.id.toString()),
                      decoration: InputDecoration(
                        labelText: 'User ID',
                        filled: true,
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              );
            }
            return CircularProgressIndicator.adaptive();
          },
        ),
      );
}
