import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../components/surface.dart';
import '../../data/settings/message_appearance.dart';
import '../../tmi/channel/messages/channel_message_ban.dart';

class ChatBanChip extends StatelessWidget {
  const ChatBanChip({
    super.key,
    required this.messageAppearance,
    required this.message,
  });

  final MessageAppearance messageAppearance;
  final ChannelMessageBan message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0 * (messageAppearance.compact ? 1.0 : 2.0)),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          Surface(
            type: message.user == null ? SurfaceType.secondary : SurfaceType.error,
            borderRadius: BorderRadius.circular(64.0 * messageAppearance.scale),
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0 * messageAppearance.scale, vertical: 8.0 * messageAppearance.scale),
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(child: Icon(message.user == null ? Icons.cleaning_services_outlined : (message.duration != null ? Icons.timer_outlined : Icons.back_hand_outlined), size: Theme.of(context).textTheme.titleLarge!.fontSize! * messageAppearance.scale)),
                        WidgetSpan(child: SizedBox(height: 8.0 * messageAppearance.scale, width: 8.0 * messageAppearance.scale)),
                        message.user == null
                            ? const TextSpan(text: AppLocalizations.of(context)!.chatCleared)
                            : TextSpan(
                                children: [
                                  TextSpan(text: '${message.user?.displayName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  if (message.duration == null) const TextSpan(text: AppLocalizations.of(context)!.permabanned),
                                  if (message.duration != null) TextSpan(text: AppLocalizations.of(context)!.bannedForDuration(message.duration.toString().split('.').first)),
                                ],
                              ),
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
