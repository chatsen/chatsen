import '/MVP/Models/MessageModel.dart';
import 'package:hive/hive.dart';

/// [MessagePresenter] is the presenter used for our message settings. It saves and loads in a [MessageModel] model.
class MessagePresenter {
  static MessageModel cache = MessageModel();

  static Future<MessageModel> loadData() async {
    var box = await Hive.openBox('Settings');
    cache = MessageModel(
      timestamps: box.containsKey('timestamps') ? box.get('timestamps') : false,
      imagePreview: box.containsKey('imagePreview') ? box.get('imagePreview') : false,
    );
    return cache;
  }

  static void saveData(MessageModel model) async {
    var box = Hive.box('Settings');
    await box.put('timestamps', model.timestamps);
    await box.put('imagePreview', model.imagePreview);
    cache = model;
  }
}
