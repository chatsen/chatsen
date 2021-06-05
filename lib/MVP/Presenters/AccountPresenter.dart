import '/MVP/Models/AccountModel.dart';
import 'package:hive/hive.dart';

/// [AccountPresenter] is the presenter used for our accounts. It saves and loads in a list of [AccountModel] models.
class AccountPresenter {
  static Future<List<AccountModel?>> loadData() async {
    var box = await Hive.openBox('Accounts');
    var data = <AccountModel?>[];
    if (box.isEmpty) {
      data.add(
        AccountModel(
          id: 0,
          clientId: 'kimne78kx3ncx6brgo4mv6wki5h1ko',
          login: 'justinfan64537',
        ),
      );
      await saveData(data);
      return await loadData();
    }
    for (var i = 0; i < box.length; ++i) {
      data.add(box.getAt(i));
    }
    return data;
  }

  static Future<void> saveData(List<AccountModel?> models) async {
    var box = await Hive.openBox('Accounts');
    await box.clear();
    await box.addAll(models);
  }

  static Future<AccountModel?> findCurrentAccount() async {
    print('first step');
    var box = await Hive.openBox('Settings');
    print('second step');
    var currentId = box.containsKey('currentAccountId') ? box.get('currentAccountId') : 0;
    var accounts = await loadData();
    print('third step');
    return accounts.firstWhere((element) => element!.isActive!, orElse: () => accounts.first);
  }

  static void setCurrentAccount(AccountModel? model) async {
    var box = await Hive.openBox('Settings');
    var currentId = box.containsKey('currentAccountId') ? box.get('currentAccountId') : 0;
    var accounts = await loadData();
    for (var account in accounts) {
      if (account!.isActive!) account.isActive = false;
      if (account.id == model!.id) account.isActive = true;
      await account.save();
    }
    saveData(accounts);
  }
}
