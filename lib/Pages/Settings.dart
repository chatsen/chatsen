import 'package:flutter/material.dart';

import 'Settings/Autocomplete.dart';
import 'Settings/Notification.dart';
import 'Settings/Message.dart';
import 'Settings/Theme.dart';

/// The [SettingsTile] widget is a wrapper around [ListTile] that enables easy subsettings tile creation.
class SettingsTile extends StatelessWidget {
  final Icon icon;
  final String title;
  final String? description;
  final Function? routeBuilder;

  const SettingsTile({
    Key? key,
    required this.icon,
    required this.title,
    this.description,
    this.routeBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: icon,
        title: Text(title),
        subtitle: description != null ? Text(description!) : null,
        onTap: routeBuilder != null
            ? () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => routeBuilder!(),
                  ),
                )
            : null,
      );
}

/// [SettingsPage] is the Home page for the settings menu. It offers redirections to the other submenus available for the different parts of the settings group.
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(
          children: [
            SettingsTile(
              icon: Icon(Icons.looks),
              title: 'Theme',
              routeBuilder: () => ThemeSettingsPage(),
            ),
            SettingsTile(
              icon: Icon(Icons.notifications),
              title: 'Notifications',
              routeBuilder: () => NotificationSettingsPage(),
            ),
            SettingsTile(
              icon: Icon(Icons.keyboard),
              title: 'Autocompletion',
              routeBuilder: () => AutocompleteSettingsPage(),
            ),
            SettingsTile(
              icon: Icon(Icons.message),
              title: 'Message Appearance',
              routeBuilder: () => MessageSettingsPage(),
            ),
          ],
        ),
      );
}
