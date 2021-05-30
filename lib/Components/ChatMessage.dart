import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import '/MVP/Presenters/MessagePresenter.dart';
import '/Pages/Search.dart';
import 'package:url_launcher/url_launcher.dart';

/// [ChatMessage] is a Widget that takes a [twitch.Message] and renders into something readable and interactable.
class ChatMessage extends StatelessWidget {
  final twitch.Message message;

  const ChatMessage({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = Color(int.tryParse(message.user.color ?? '777777', radix: 16) ?? 0x777777).withAlpha(255);
    var spans = <InlineSpan>[];

    for (var token in message.tokens) {
      switch (token.type) {
        case twitch.MessageTokenType.Text:
          spans.add(
            TextSpan(
              text: '${token.data} ',
              style: TextStyle(color: message.action ? color : null),
            ),
          );
          break;
        case twitch.MessageTokenType.Link:
          spans.add(
            TextSpan(
              children: [
                TextSpan(
                  text: '${token.data}',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () async => launch(token.data),
                ),
                TextSpan(text: ' '),
              ],
            ),
          );
          break;
        case twitch.MessageTokenType.Image:
          if (!MessagePresenter.cache.imagePreview) {
            spans.add(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${token.data}',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () async => launch(token.data),
                  ),
                  TextSpan(text: ' '),
                ],
              ),
            );
            break;
          }

          spans.add(
            TextSpan(
              children: [
                TextSpan(text: '\n'),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: InkWell(
                      child: Image.network('${token.data}'),
                      onTap: () async => launch(token.data),
                    ),
                  ),
                ),
                TextSpan(text: '\n'),
              ],
            ),
          );
          break;
        case twitch.MessageTokenType.Video:
          break;
        case twitch.MessageTokenType.Emote:
          spans.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Image.network(token.data.mipmap[0]),
              ),
            ),
          );
          break;
        case twitch.MessageTokenType.EmoteStack:
          for (var emote in token.data) {
            spans.add(
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Image.network(emote.mipmap[0]),
                ),
              ),
            );
          }
          break;
        case twitch.MessageTokenType.User:
          break;
      }
    }

    return InkWell(
      onLongPress: () async => await Clipboard.setData(ClipboardData(text: message.body)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
        child: Text.rich(
          TextSpan(
            children: <InlineSpan>[
                  if (MessagePresenter.cache.timestamps)
                    TextSpan(
                      text: '${message.dateTime.hour.toString().padLeft(2, '0')}:${message.dateTime.minute.toString().padLeft(2, '0')} ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  for (var badge in message.badges)
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Image.network(badge.mipmap[0]),
                      ),
                    ),
                  TextSpan(
                    text: '${message.user.displayName}' + (message.user.displayName.toLowerCase() != message.user.login.toLowerCase() ? ' (${message.user.login})' : '') + (message.action ? ' ' : ': '),
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => SearchPage(channel: message.channel, user: message.user),
                            ),
                          ),
                  ),
                ] +
                spans,
          ),
        ),
      ),
    );
  }
}
