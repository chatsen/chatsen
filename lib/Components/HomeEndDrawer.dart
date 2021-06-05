import 'package:chatsen/Components/ChatMessage.dart';
import 'package:chatsen/Mentions/MentionsCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_next/WidgetBlur.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class HomeEndDrawer extends StatelessWidget {
  const HomeEndDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<MentionsCubit, List<twitch.Message>>(
        builder: (context, state) {
          return WidgetBlur(
            child: Material(
              color: Theme.of(context).canvasColor.withAlpha(196),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 1.0,
                        color: Theme.of(context).dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 2.0,
                          height: 48.0,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      Expanded(
                        child: state.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.alternate_email, size: 48.0),
                                  SizedBox(height: 4.0),
                                  Text.rich(
                                    TextSpan(
                                      text: 'Mentions would go here\n...if you had any ',
                                      children: [
                                        WidgetSpan(child: Image.network('https://cdn.frankerfacez.com/emote/425196/1')),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            : ListView(
                                reverse: true,
                                children: [
                                  for (var message in state.reversed)
                                    ChatMessage(
                                      prefixText: message.channel!.name,
                                      message: message,
                                    ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
}
