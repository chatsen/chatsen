import 'dart:math';

import 'package:chatsen/Components/UI/BlurModal.dart';
import 'package:chatsen/Components/UI/Tile.dart';
import 'package:chatsen/Settings/Settings.dart';
import 'package:chatsen/Settings/SettingsEvent.dart';
import 'package:chatsen/Settings/SettingsState.dart';
import 'package:chatsen/Theme/ThemeBloc.dart';
import 'package:chatsen/Theme/ThemeEvent.dart';
import 'package:chatsen/Theme/ThemeManager.dart';
import 'package:chatsen/Theme/ThemeState.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Commands.dart';

class SettingsEntry extends StatelessWidget {
  final String? category;
  final String title;
  final String? description;
  final Function(BuildContext context, String? category, String title, String? description) builder;

  const SettingsEntry({
    Key? key,
    this.category,
    required this.title,
    this.description,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => builder(context, category, title, description);
}

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => SizedBox.expand(child: child);

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocBuilder<Settings, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoaded) {
              var entries = [
                SettingsEntry(
                  category: 'Theme',
                  title: 'Color',
                  description: 'Change the primary color of the application',
                  builder: (context, category, title, description) => Tile(
                    onTap: () async => BlurModal.show(
                      context: context,
                      child: BlocBuilder<ThemeBloc, ThemeState>(
                        builder: (context, state) => SafeArea(
                          child: Material(
                            child: SizedBox(
                              child: GridView.extent(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                maxCrossAxisExtent: 16.0 * 5.0,
                                children: [
                                  for (var colorScheme in ThemeManager.colors.entries)
                                    Tooltip(
                                      message: colorScheme.key,
                                      child: InkWell(
                                        onTap: () => BlocProvider.of<ThemeBloc>(context).add(ThemeColorSchemeChanged(colorScheme: colorScheme.key)),
                                        child: Ink(
                                          color: colorScheme.value.first,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 2.0,
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(32.0),
                        clipBehavior: Clip.antiAlias,
                        child: SizedBox(width: 24.0, height: 24.0),
                      ),
                    ),
                    title: title,
                    subtitle: description,
                  ),
                ),
                SettingsEntry(
                  category: 'Theme',
                  title: 'Brightness',
                  description: 'Change between light and dark theme',
                  builder: (context, category, title, description) => Tile(
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.wb_sunny_outlined),
                    ),
                    onTap: () => BlocProvider.of<ThemeBloc>(context).add(
                      ThemeModeChanged(
                        mode: (BlocProvider.of<ThemeBloc>(context).state as ThemeLoaded).mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
                      ),
                    ),
                    title: title,
                    subtitle: description,
                  ),
                ),
                SettingsEntry(
                  category: 'Setup',
                  title: 'Setup screen',
                  description: 'Show the setup screen next startup',
                  builder: (context, category, title, description) => Tile(
                    title: title,
                    subtitle: description,
                    onTap: () => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(setupScreen: !state.setupScreen))),
                    trailing: Switch.adaptive(
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (bool value) => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(setupScreen: value))),
                      value: state.setupScreen,
                    ),
                  ),
                ),
                SettingsEntry(
                  category: 'Notifications',
                  title: 'Notification on whispers',
                  description: 'Sends a system notification when a whisper is received',
                  builder: (context, category, title, description) => Tile(
                    title: title,
                    subtitle: description,
                    onTap: () => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(notificationOnWhisper: !state.notificationOnWhisper))),
                    trailing: Switch.adaptive(
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (bool value) => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(notificationOnWhisper: value))),
                      value: state.notificationOnWhisper,
                    ),
                  ),
                ),
                SettingsEntry(
                  category: 'Notifications',
                  title: 'Notification on mentions',
                  description: 'Sends a system notification when you are mentionned in an open chat',
                  builder: (context, category, title, description) => Tile(
                    title: title,
                    subtitle: description,
                    onTap: () => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(notificationOnMention: !state.notificationOnMention))),
                    trailing: Switch.adaptive(
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (bool value) => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(notificationOnMention: value))),
                      value: state.notificationOnMention,
                    ),
                  ),
                ),
                // SettingsEntry(
                //   category: 'Notifications',
                //   title: 'Custom mentions',
                //   description: 'A list of custom words or regexes that mentions you',
                //   builder: (context, category, title, description) => Tile(
                //     title: title,
                //     subtitle: description,
                //     onTap: () {},
                //   ),
                // ),
                SettingsEntry(
                  category: 'Message',
                  title: 'Show timestamp',
                  description: 'Displays the time at which a message has been sent',
                  builder: (context, category, title, description) => Tile(
                    title: title,
                    subtitle: description,
                    onTap: () => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(messageTimestamp: !state.messageTimestamp))),
                    trailing: Switch.adaptive(
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (bool value) => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(messageTimestamp: value))),
                      value: state.messageTimestamp,
                    ),
                  ),
                ),
                SettingsEntry(
                  category: 'Message',
                  title: 'Show images previews',
                  description: 'Replaces image links with the images themselves',
                  builder: (context, category, title, description) => Tile(
                    title: title,
                    subtitle: description,
                    onTap: () => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(messageImagePreview: !state.messageImagePreview))),
                    trailing: Switch.adaptive(
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (bool value) => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(messageImagePreview: value))),
                      value: state.messageImagePreview,
                    ),
                  ),
                ),
                SettingsEntry(
                  category: 'Message',
                  title: 'Line separators',
                  description: 'Separates every message with a line',
                  builder: (context, category, title, description) => Tile(
                    title: title,
                    subtitle: description,
                    onTap: () => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(messageLines: !state.messageLines))),
                    trailing: Switch.adaptive(
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (bool value) => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(messageLines: value))),
                      value: state.messageLines,
                    ),
                  ),
                ),
                // for (var i = 0; i < 10; ++i)
                SettingsEntry(
                  category: 'Message',
                  title: 'Alternate background color',
                  description: 'Changes the background color for each message as a separation',
                  builder: (context, category, title, description) => Tile(
                    title: title,
                    subtitle: description,
                    onTap: () => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(messageAlternateBackground: !state.messageAlternateBackground))),
                    trailing: Switch.adaptive(
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (bool value) => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(messageAlternateBackground: value))),
                      value: state.messageAlternateBackground,
                    ),
                  ),
                ),
                SettingsEntry(
                  category: '3rd-party services',
                  title: 'Load chat history from recent-messages',
                  description: 'Uses a 3rd-party service by @randers to load chat history',
                  builder: (context, category, title, description) => Tile(
                    leading: InkWell(
                      borderRadius: BorderRadius.circular(32.0),
                      onTap: () => launch('https://recent-messages.robotty.de/'),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.history),
                      ),
                    ),
                    title: title,
                    subtitle: description,
                    onTap: () => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(historyEnabled: !state.historyUseRecentMessages))),
                    trailing: Switch.adaptive(
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (bool value) => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(historyEnabled: value))),
                      value: state.historyUseRecentMessages,
                    ),
                  ),
                ),
                SettingsEntry(
                  category: 'Commands',
                  title: 'Configure custom commands',
                  description: 'Allows you to create and configure custom commands to be used in chat',
                  builder: (context, category, title, description) => Tile(
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.text_format),
                      ),
                      title: title,
                      subtitle: description,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommandsPage()))),
                ),
                SettingsEntry(
                  category: 'About',
                  title: 'Show open-source licenses',
                  description: 'Display the list of licenses used by dependencies',
                  builder: (context, category, title, description) => Tile(
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.info),
                    ),
                    title: title,
                    subtitle: description,
                    onTap: () => showLicensePage(context: context),
                  ),
                ),
                SettingsEntry(
                  category: 'About',
                  // title: 'Check for updates',
                  title: 'About Chatsen',
                  description: 'Version',
                  builder: (context, category, title, description) => FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) => Tile(
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.system_security_update),
                      ),
                      title: title,
                      subtitle: snapshot.hasData ? 'Running ${snapshot.data!.packageName} ${snapshot.data!.version}+${snapshot.data!.buildNumber}' : null,
                    ),
                  ),
                ),
              ];

              var listChildren = [
                for (var entryGroup in groupBy<SettingsEntry, String?>(entries.where((entry) => (entry.category?.toLowerCase().contains(searchController.text.toLowerCase()) ?? false) || entry.title.toLowerCase().contains(searchController.text.toLowerCase()) || (entry.description?.toLowerCase().contains(searchController.text.toLowerCase()) ?? false)), (x) => x.category).entries) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 4.0),
                    child: Text(
                      '${entryGroup.key}',
                      style: Theme.of(context).textTheme.button!.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  for (var entry in entryGroup.value) entry,
                ],
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ];

              return CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 128.0 * 1.5,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0) + EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 24.0),
                            Container(
                              width: 24.0,
                              height: 24.0,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () => Navigator.of(context).pop(),
                                padding: EdgeInsets.zero,
                                iconSize: 24.0,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Settings',
                              style: Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    // pinned: true,
                    floating: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: 64.0 + MediaQuery.of(context).padding.top,
                      maxHeight: 64.0 + MediaQuery.of(context).padding.top,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0) + EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                        child: Material(
                          borderRadius: BorderRadius.circular(64.0),
                          color: Theme.of(context).colorScheme.surface,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Center(
                              child: Row(
                                children: [
                                  Icon(Icons.search),
                                  SizedBox(
                                    width: 12.0,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search settings',
                                        isDense: true,
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) => listChildren[index],
                      childCount: listChildren.length,
                    ),
                  ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator.adaptive());
          },
        ),
      );
}


/*
                  // SliverAppBar(
                  //   pinned: false,
                  //   snap: false,
                  //   floating: true,
                  //   expandedHeight: 128.0 * 1.5,
                  //   // titleSpacing: 0.0,
                  //   // leading: Container(),
                  //   // leadingWidth: 0.0,
                  //   // automaticallyImplyLeading: false,
                  //   flexibleSpace: FlexibleSpaceBar(
                  //     title: Row(
                  //       children: [
                  //         Container(
                  //           width: 24.0,
                  //           height: 24.0,
                  //           child: IconButton(
                  //             icon: Icon(Icons.arrow_back),
                  //             onPressed: () => Navigator.of(context).pop(),
                  //             padding: EdgeInsets.zero,
                  //             iconSize: 24.0,
                  //           ),
                  //         ),
                  //         SizedBox(width: 8.0),
                  //         Text('Settings'),
                  //       ],
                  //     ),
                  //     titlePadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  //   ),
                  // ),
*/
