import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/components/modal.dart';
import '../modal/chatsen.dart';
import '/components/boxlistener.dart';

class AvatarButton extends StatefulWidget {
  const AvatarButton({super.key});

  @override
  State<AvatarButton> createState() => _AvatarButtonState();
}

enum AvatarButtonDirection {
  up,
  down,
  none,
}

class _AvatarButtonState extends State<AvatarButton> {
  AvatarButtonDirection direction = AvatarButtonDirection.none;

  @override
  Widget build(BuildContext context) {
    return BoxListener(
      box: Hive.box('AccountSettings'),
      builder: (context, accountSettingsBox) {
        return BoxListener(
          box: Hive.box('TwitchAccounts'),
          builder: (BuildContext context, Box twitchAccountsBox) {
            final twitchAccount = twitchAccountsBox.values.firstWhere((element) => accountSettingsBox.get('activeTwitchAccount') == element.tokenData.hash, orElse: () => null);
            return Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24.0),
              clipBehavior: Clip.antiAlias,
              child: GestureDetector(
                onPanStart: (details) {
                  direction = AvatarButtonDirection.none;
                },
                onPanUpdate: (details) {
                  if (details.delta.dy > 1.0) {
                    direction = AvatarButtonDirection.down;
                  } else if (details.delta.dy < -1.0) {
                    direction = AvatarButtonDirection.up;
                  } else {
                    direction = AvatarButtonDirection.none;
                  }
                },
                onPanEnd: (details) {
                  var activeAccountHash = accountSettingsBox.get('activeTwitchAccount');
                  var indexOfActiveAccountHash = twitchAccountsBox.keys.toList().indexOf(activeAccountHash);
                  switch (direction) {
                    case AvatarButtonDirection.up:
                      ++indexOfActiveAccountHash;
                      if (indexOfActiveAccountHash >= twitchAccountsBox.length) indexOfActiveAccountHash = 0;
                      break;
                    case AvatarButtonDirection.down:
                      --indexOfActiveAccountHash;
                      if (indexOfActiveAccountHash < 0) indexOfActiveAccountHash = twitchAccountsBox.keys.toList().length - 1;
                      break;
                    case AvatarButtonDirection.none:
                      break;
                  }
                  accountSettingsBox.put('activeTwitchAccount', twitchAccountsBox.keys.elementAt(indexOfActiveAccountHash));
                  direction = AvatarButtonDirection.none;
                },
                child: InkWell(
                  onTap: () async {
                    Modal.show(
                      context: context,
                      child: const ChatsenModal(),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(24.0),
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        width: 32.0,
                        height: 32.0,
                        child: Ink.image(
                          image: NetworkImage(twitchAccount.userData.avatarUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
