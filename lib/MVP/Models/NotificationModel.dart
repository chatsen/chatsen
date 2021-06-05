/// The [NotificationModel] is a class that holds our settings for the notifications.
class NotificationModel {
  bool? mentionNotification;
  bool? whisperNotification;

  NotificationModel({
    this.mentionNotification = true,
    this.whisperNotification = true,
  });
}
