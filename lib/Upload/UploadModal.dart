import 'package:chatsen/Components/UI/BlurModal.dart';
import 'package:flutter/material.dart';

class UploadModal extends StatelessWidget {
  const UploadModal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.upload),
            ),
            title: Text('Select a file'),
            subtitle: Text('Opens a file picker to select a file to upload'),
            onTap: () {},
          ),
        ],
      );

  static Future<void> show({@required BuildContext context}) async {
    await BlurModal.show(
      context: context,
      child: UploadModal(),
    );
  }
}
