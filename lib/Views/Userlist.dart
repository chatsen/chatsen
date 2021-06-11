import 'package:flutter/material.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

/// The [UserlistView] class is a view designed to hold the list of users currently connected to a channel. It can be refreshed with a pull-to-refresh swipe movement.
class UserlistView extends StatefulWidget {
  final twitch.Channel? channel;

  const UserlistView({
    Key? key,
    required this.channel,
  }) : super(key: key);

  @override
  _UserlistViewState createState() => _UserlistViewState();
}

class _UserlistViewState extends State<UserlistView> {
  Future<dynamic>? gqlFuture;
  TextEditingController tec = TextEditingController();

  void refreshUserlist() async => gqlFuture = widget.channel!.updateUsers();

  @override
  void initState() {
    refreshUserlist();
    super.initState();
  }

  @override
  void dispose() {
    tec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: gqlFuture,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var userlistWidgets = <Widget>[];
            for (var group in widget.channel!.users.entries) {
              if (group.value.isEmpty || !group.value.any((x) => x.toLowerCase().contains(tec.text.toLowerCase()))) continue;

              userlistWidgets.add(
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 12.0),
                  child: Text(
                    group.key,
                    style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              );

              for (var user in group.value.where((x) => x.toLowerCase().contains(tec.text.toLowerCase()))) {
                userlistWidgets.add(
                  InkWell(
                    onTap: () async {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                      child: Text(user),
                    ),
                  ),
                );
              }
            }

            return RefreshIndicator(
              onRefresh: () async => refreshUserlist(),
              child: Column(
                children: [
                  TextField(
                    controller: tec,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      filled: false,
                      isDense: true,
                      hintText: 'Search usernames',
                      border: InputBorder.none,
                    ),
                    onChanged: (v) => setState(() {}),
                    // onSubmitted: (text) async => submit(),
                  ),
                  Expanded(
                    child: ListView(
                      children: userlistWidgets,
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator.adaptive());
        },
      );
}
