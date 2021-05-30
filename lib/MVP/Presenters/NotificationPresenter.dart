import '/MVP/Models/NotificationModel.dart';
import 'package:hive/hive.dart';

/// [NotificationPresenter] is the presenter used for our notification settings. It saves and loads in a [NotificationModel] model.
class NotificationPresenter {
  static NotificationModel cache = NotificationModel();

  static Future<NotificationModel> loadData() async {
    var box = await Hive.openBox('Settings');
    cache = NotificationModel(
      mentionNotification: box.containsKey('mentionNotification') ? box.get('mentionNotification') : false,
      whisperNotification: box.containsKey('whisperNotification') ? box.get('whisperNotification') : false,
    );
    return cache;
  }

  static void saveData(NotificationModel model) async {
    var box = Hive.box('Settings');
    await box.put('mentionNotification', model.mentionNotification);
    await box.put('whisperNotification', model.whisperNotification);
    cache = model;
  }
}
