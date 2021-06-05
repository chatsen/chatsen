import 'package:chatsen/Components/WidgetTooltip.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import '/MVP/Presenters/MessagePresenter.dart';
import '/Pages/Search.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'dart:async';

/// [ChatMessage] is a Widget that takes a [twitch.Message] and renders into something readable and interactable.
class ChatMessage extends StatelessWidget {
  final String? prefixText;
  final twitch.Message message;

  const ChatMessage({
    Key? key,
    this.prefixText,
    required this.message,
  }) : super(key: key);

  Color getUserColor(BuildContext context, Color color) {
    switch (Theme.of(context).brightness) {
      case Brightness.dark:
        final hsl = HSLColor.fromColor(Color(color.value == 0xFF000000 ? 0xFF010101 : color.value));
        return hsl.withLightness(hsl.lightness.clamp(0.6, 1.0)).toColor();
      case Brightness.light:
        final hsl = HSLColor.fromColor(Color(color.value == 0xFF000000 ? 0xFF010101 : color.value));
        return hsl.withLightness(hsl.lightness.clamp(0.0, 0.4)).toColor();
    }
  }

  Future<ui.Image> imageFromUrl(String url) {
    var completer = Completer<ui.Image>();
    NetworkImage(url).resolve(ImageConfiguration()).addListener(ImageStreamListener((image, synchronousCall) {
      completer.complete(image.image);
    }));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    var color = getUserColor(context, Color(int.tryParse(message.user!.color ?? '777777', radix: 16) ?? 0x777777).withAlpha(255));
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
          if (!MessagePresenter.cache.imagePreview!) {
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
                      onTap: () async => launch(token.data),
                      child: Image.network('${token.data}'),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WidgetTooltip(
                    message: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Image.network(
                              (token.data as twitch.Emote).mipmap!.last!,
                              isAntiAlias: true,
                              filterQuality: FilterQuality.high,
                              height: 96.0,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          Text((token.data as twitch.Emote).name!),
                          Text((token.data as twitch.Emote).provider!),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Image.network(
                        token.data.provider == 'Twitch' ? token.data.mipmap[1] : token.data.mipmap.last,
                        filterQuality: FilterQuality.high,
                        isAntiAlias: true,
                        scale: token.data.provider == 'Twitch' ? 2.0 : 4.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          break;
        case twitch.MessageTokenType.EmoteStack:
          spans.add(
            WidgetSpan(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (var emote in token.data)
                    WidgetTooltip(
                      message: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Image.network(
                                (token.data as List<twitch.Emote>).first.mipmap!.last!,
                                isAntiAlias: true,
                                filterQuality: FilterQuality.high,
                                height: 96.0,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Text((token.data as List<twitch.Emote>).first.name!),
                            Text((token.data as List<twitch.Emote>).first.provider!),
                            for (var emote in (token.data as List<twitch.Emote>).sublist(1))
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Image.network(emote.mipmap!.first!),
                                    ),
                                    Text(emote.name!),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Image.network(
                          emote.provider == 'Twitch' ? emote.mipmap[1] : emote.mipmap.last,
                          filterQuality: FilterQuality.high,
                          isAntiAlias: true,
                          scale: emote.provider == 'Twitch' ? 2.0 : 4.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
          break;
        case twitch.MessageTokenType.User:
          break;
      }
    }

    return Container(
      color: message.mention ? Theme.of(context).primaryColor.withAlpha(48) : null,
      child: InkWell(
        onLongPress: () async => await Clipboard.setData(ClipboardData(text: message.body)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
          child: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                    if (prefixText != null)
                      TextSpan(
                        text: '$prefixText ',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    if (MessagePresenter.cache.timestamps!)
                      TextSpan(
                        text: '${message.dateTime!.hour.toString().padLeft(2, '0')}:${message.dateTime!.minute.toString().padLeft(2, '0')} ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    for (var badge in message.badges)
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Image.network(
                            badge.mipmap!.last!,
                            filterQuality: FilterQuality.high,
                            isAntiAlias: true,
                            scale: 4.0,
                          ),
                        ),
                      ),
                    TextSpan(
                      text: '${message.user!.displayName}' + (message.user!.displayName!.toLowerCase() != message.user!.login!.toLowerCase() ? ' (${message.user!.login})' : '') + (message.action ? ' ' : ': '),
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
      ),
    );
  }
}
