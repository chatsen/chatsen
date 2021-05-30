import 'package:flutter/material.dart';
import '/MVP/Views/MessageView.dart';

/// [MessageSettingsPage] is the Page scaffold representing our app's message settings. It allows changing how each message renders.
class MessageSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Message Appearance'),
        ),
        body: MessageView(),
      );
}
