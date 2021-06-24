import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'AccountModel.dart';

class AccountsCubit extends Cubit<List<AccountModel>> {
  Box accountBox;

  static AccountModel defaultAccount = AccountModel(
    id: 0,
    clientId: 'kimne78kx3ncx6brgo4mv6wki5h1ko',
    login: 'justinfan64537',
  );

  AccountsCubit(this.accountBox) : super([]) {
    refresh();
  }

  Future<void> refresh() async {
    emit([
      for (var account in accountBox.values) account as AccountModel,
    ]);
  }

  Future<void> add(AccountModel account) async {
    await accountBox.add(account);
    emit([...state, account]);
  }

  Future<void> remove(AccountModel account) async {
    await account.delete();
    emit([...state]..remove(account));
  }

  Future<AccountModel> getActive() async {
    return state.firstWhere((account) => account.isActive ?? false, orElse: () => defaultAccount);
  }

  Future<void> setActive(AccountModel activeAccount) async {
    for (var account in state) {
      account.isActive = false;
      await account.save();
    }
    activeAccount.isActive = true;
    await activeAccount.save();
    emit([...state]);
  }
}
