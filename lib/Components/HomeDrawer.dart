import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_next/WidgetBlur.dart';
import '/Pages/Account.dart';
import '/Pages/Profile.dart';
import '/Pages/Search.dart';
import '/Pages/Settings.dart';
import '/Pages/Whispers.dart';
import '/StreamOverlay/StreamOverlayBloc.dart';
import '/StreamOverlay/StreamOverlayEvent.dart';
import '/StreamOverlay/StreamOverlayState.dart';
import '/Views/Userlist.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

/// The [HomeDrawer] widget represents the drawer available on the home page. It features our [UserlistView] which displays all the users currently in a channel as well as giving us the way to access multiple options, accounts and features.
class HomeDrawer extends StatelessWidget {
  final twitch.Client? client;
  final twitch.Channel? channel;

  const HomeDrawer({
    Key? key,
    required this.client,
    required this.channel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => WidgetBlur(
        child: Material(
          color: Theme.of(context).canvasColor.withAlpha(196),
          child: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: channel != null
                          ? UserlistView(
                              channel: channel,
                            )
                          : ListView(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        elevation: 8.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (channel != null)
                              IconButton(
                                icon: Icon(Icons.play_arrow),
                                onPressed: () async => (BlocProvider.of<StreamOverlayBloc>(context).state is StreamOverlayClosed) ? BlocProvider.of<StreamOverlayBloc>(context).add(StreamOverlayOpen(channelName: channel!.name!.substring(1))) : BlocProvider.of<StreamOverlayBloc>(context).add(StreamOVerlayClose()), //launch('https://twitch.tv/${channel.name.substring(1)}'),
                                tooltip: 'Open current channel\'s stream',
                              ),
                            if (channel != null)
                              IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => SearchPage(
                                      channel: channel,
                                    ),
                                  ),
                                ),
                                tooltip: 'Search in the current channel',
                              ),
                            if (channel != null)
                              Container(
                                width: 1.0,
                                height: 24.0,
                                color: Theme.of(context).dividerColor,
                              ),
                            IconButton(
                              icon: Icon(Icons.inbox),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => WhispersPage(
                                    client: client,
                                  ),
                                ),
                              ),
                              tooltip: 'Open whispers',
                            ),
                            IconButton(
                              icon: Icon(Icons.switch_account),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => AccountPage(
                                    client: client,
                                  ),
                                ),
                              ),
                              tooltip: 'Add or switch between your accounts',
                            ),
                            IconButton(
                              icon: Icon(Icons.account_circle),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => ProfilePage(),
                                ),
                              ),
                              tooltip: 'Get your profile information',
                            ),
                            IconButton(
                              icon: Icon(Icons.settings),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => SettingsPage(),
                                ),
                              ),
                              tooltip: 'Opens the settings page',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 2.0,
                      height: 48.0,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  Container(
                    width: 1.0,
                    color: Theme.of(context).dividerColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
