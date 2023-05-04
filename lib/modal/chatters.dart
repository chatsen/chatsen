import 'package:chatsen/components/tile.dart';
import 'package:chatsen/modal/components/modal_header.dart';
import 'package:chatsen/modal/user.dart';
import 'package:chatsen/tmi/channel/channel.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/modal.dart';

class ChattersModal extends StatefulWidget {
  final Channel channel;

  const ChattersModal({
    super.key,
    required this.channel,
  });

  @override
  State<ChattersModal> createState() => _ChattersModalState();
}

class _ChattersModalState extends State<ChattersModal> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          children: [
            ModalHeader(title: AppLocalizations.of(context)!.chatters),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Material(
                borderRadius: BorderRadius.circular(128.0),
                // color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      isDense: true,
                    ),
                    onChanged: (text) => setState(() {}),
                  ),
                ),
              ),
            ),
            for (final chatter in widget.channel.channelChatters.state!.getAllChatters().where((element) => element.login.toLowerCase().contains(searchController.text.toLowerCase()) || element.displayName.toLowerCase().contains(searchController.text.toLowerCase())))
              Tile(
                prefix: CircleAvatar(
                  backgroundImage: NetworkImage(chatter.profileImageURL),
                ),
                title: chatter.displayName,
                // subtitle: chatter.login,
                onTap: () {
                  Modal.show(
                    context: context,
                    child: UserModal(
                      login: chatter.login,
                      channel: widget.channel,
                    ),
                  );
                },
              ),
          ],
        ),
      );
}
