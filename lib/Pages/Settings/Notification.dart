import 'package:flutter/material.dart';
import '/MVP/Views/NotificationView.dart';

/// [NotificationSettingsPage] is the Page scaffold representing our app's notification settings. It allows changing the behavior for notifications received while the application is running.
class NotificationSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Notification Settings'),
        ),
        body: NotificationView(),
      );
}
