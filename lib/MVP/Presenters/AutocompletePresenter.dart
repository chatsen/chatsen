import '/MVP/Models/AutocompleteModel.dart';
import 'package:hive/hive.dart';

/// [AutocompletePresenter] is the presenter used for our Autocomplete settings. It saves and loads in a [AutocompleteModel] model.
class AutocompletePresenter {
  static AutocompleteModel cache = AutocompleteModel();

  static Future<AutocompleteModel> loadData() async {
    var box = await Hive.openBox('Settings');
    cache = AutocompleteModel(
      userPrefix: box.containsKey('userPrefix') ? box.get('userPrefix') : false,
      emotePrefix: box.containsKey('emotePrefix') ? box.get('emotePrefix') : false,
    );
    return cache;
  }

  static void saveData(AutocompleteModel model) async {
    var box = Hive.box('Settings');
    await box.put('userPrefix', model.userPrefix);
    await box.put('emotePrefix', model.emotePrefix);
    cache = model;
  }
}
