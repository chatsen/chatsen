import 'package:chatsen/Components/UI/BlurModal.dart';
import 'package:chatsen/Components/UI/Tile.dart';
import 'package:chatsen/Settings/Settings.dart';
import 'package:chatsen/Settings/SettingsEvent.dart';
import 'package:chatsen/Settings/SettingsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SetupModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<Settings, SettingsState>(
        builder: (context, state) => (state is SettingsLoaded)
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome to Chatsen!', style: Theme.of(context).textTheme.headline5),
                        Text('Before getting started, please review the following settings.'),
                      ],
                    ),
                  ),
                  Tile(
                    leading: InkWell(
                      borderRadius: BorderRadius.circular(32.0),
                      onTap: () => launch('https://recent-messages.robotty.de/'),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.info),
                      ),
                    ),
                    title: 'Enable chat history',
                    subtitle: 'Load the chat history from a 3rd-party service that receives the channel names you join to provide you the previous messages. To learn more, click the icon button.',
                    onTap: () => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(historyEnabled: !state.historyUseRecentMessages))),
                    trailing: Switch.adaptive(
                      onChanged: (bool value) => BlocProvider.of<Settings>(context).add(SettingsChange(state: state.copyWith(historyEnabled: value))),
                      value: state.historyUseRecentMessages,
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Continue'),
                      ),
                      SizedBox(width: 16.0),
                    ],
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator.adaptive(),
              ),
      );

  static Future<void> show(BuildContext context) async => await BlurModal.show(
        context: context,
        child: SetupModal(),
      );
}
