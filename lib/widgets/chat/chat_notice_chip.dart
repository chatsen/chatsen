import 'package:flutter/material.dart';

import '../../components/surface.dart';
import '../../data/settings/message_appearance.dart';
import '../../tmi/channel/messages/channel_message_notice.dart';

class ChatNoticeChip extends StatelessWidget {
  const ChatNoticeChip({
    super.key,
    required this.messageAppearance,
    required this.message,
  });

  final MessageAppearance messageAppearance;
  final ChannelMessageNotice message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0 * (messageAppearance.compact ? 1.0 : 2.0)),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          Surface(
            type: SurfaceType.tertiary,
            borderRadius: BorderRadius.circular(18.0 * messageAppearance.scale),
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0 * messageAppearance.scale, vertical: 8.0 * messageAppearance.scale),
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(child: Icon(Icons.info_outline, size: Theme.of(context).textTheme.titleLarge!.fontSize! * messageAppearance.scale)),
                        WidgetSpan(child: SizedBox(height: 8.0 * messageAppearance.scale, width: 8.0 * messageAppearance.scale)),
                        TextSpan(text: message.text),
                      ],
                    ),
                    style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize! * messageAppearance.scale),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
