import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// [NotificationWrapper] is a widget-wrapper that allows to access a notification system from anywhere in the build layout.
class NotificationWrapper extends StatefulWidget {
  final Widget child;

  const NotificationWrapper({
    required this.child,
  });

  static _NotificationWrapperState? of(BuildContext context) => context.findAncestorStateOfType<_NotificationWrapperState>();

  @override
  _NotificationWrapperState createState() => _NotificationWrapperState();
}

class _NotificationWrapperState extends State<NotificationWrapper> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> onSelectNotification(String? payload) async {}

  int currentNotificationIndex = 0;

  Future<void> sendNotification({
    String? payload,
    String? title,
    String? subtitle,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      currentNotificationIndex,
      title,
      subtitle,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'Twitchat',
          'Twitchat',
          'Twitchat',
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: IOSNotificationDetails(),
      ),
      payload: payload,
    );
    ++currentNotificationIndex;
  }

  @override
  void initState() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin()
      ..initialize(
        InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: IOSInitializationSettings(),
        ),
        onSelectNotification: onSelectNotification,
      );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
