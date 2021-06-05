import 'package:flutter/material.dart';
import '/MVP/Presenters/MessagePresenter.dart';

/// [MessageView] is our settings view that allows to change settings related to the way messages renders. It uses the [MessagePresenter] to fetch and save a [MessageModel] model that contains our configuration.
class MessageView extends StatefulWidget {
  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: MessagePresenter.loadData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                SwitchListTile.adaptive(
                  title: Text('Timestamps'),
                  value: snapshot.data.timestamps,
                  onChanged: (value) async {
                    snapshot.data.timestamps = value;
                    MessagePresenter.saveData(snapshot.data);
                    setState(() {});
                  },
                ),
                SwitchListTile.adaptive(
                  title: Text('Image Preview'),
                  value: snapshot.data.imagePreview,
                  onChanged: (value) async {
                    snapshot.data.imagePreview = value;
                    MessagePresenter.saveData(snapshot.data);
                    setState(() {});
                  },
                ),
              ],
            );
          }
          return CircularProgressIndicator.adaptive();
        },
      );
}
