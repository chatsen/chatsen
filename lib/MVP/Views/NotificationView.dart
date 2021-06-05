import 'package:flutter/material.dart';
import '/MVP/Presenters/MessagePresenter.dart';
import '/MVP/Presenters/NotificationPresenter.dart';

/// [NotificationView] is our settings view that allows to change settings related to the notifications. It uses the [NotificationPresenter] to fetch and save a [NotificationModel] model that contains our configuration.
class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: NotificationPresenter.loadData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                SwitchListTile.adaptive(
                  title: Text('Notification on Mentions'),
                  value: snapshot.data.mentionNotification,
                  onChanged: (value) async {
                    snapshot.data.mentionNotification = value;
                    NotificationPresenter.saveData(snapshot.data);
                    setState(() {});
                  },
                ),
                SwitchListTile.adaptive(
                  title: Text('Notification on Whispers'),
                  value: snapshot.data.whisperNotification,
                  onChanged: (value) async {
                    snapshot.data.whisperNotification = value;
                    NotificationPresenter.saveData(snapshot.data);
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
