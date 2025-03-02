import 'package:chatsen/data/notifications_cubit.dart';
import 'package:chatsen/modal/components/modal_header.dart';
import 'package:chatsen/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatsen/l10n/app_localizations.dart';

class NotificationsModal extends StatelessWidget {
  const NotificationsModal({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<NotificationsCubit>(context).clearUnreads();
    return BlocBuilder<NotificationsCubit, NotificationsCubitState>(
      bloc: BlocProvider.of<NotificationsCubit>(context),
      builder: (BuildContext context, state) => ListView(
        shrinkWrap: true,
        children: [
          ModalHeader(
            title: AppLocalizations.of(context)!.notifications,
            trailing: Tooltip(
              message: AppLocalizations.of(context)!.clearAll,
              child: InkWell(
                onTap: () async {
                  Navigator.of(context).pop();
                  BlocProvider.of<NotificationsCubit>(context).clear();
                },
                borderRadius: BorderRadius.circular(24.0),
                child: const SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: Icon(Icons.clear_all_outlined),
                ),
              ),
            ),
          ),
          if (state.messages.isEmpty) ...[
            const SizedBox(height: 16.0),
            const Center(child: Icon(Icons.info_outline)),
            const SizedBox(height: 6.0),
            Center(
              child: Text(AppLocalizations.of(context)!.noNotifications),
            ),
            const SizedBox(height: 16.0),
          ],
          ...state.messages.map((e) => ChatMessage(
                message: e,
                renderMentions: false,
              )),
        ],
      ),
    );
  }
}
