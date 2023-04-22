import 'package:chatsen/modal/components/modal_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsModal extends StatelessWidget {
  const NotificationsModal({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        children: [
          ModalHeader(
            title: AppLocalizations.of(context)!.notifications,
            trailing: Tooltip(
              message: AppLocalizations.of(context)!.clearAll,
              child: InkWell(
                onTap: () async => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(24.0),
                child: const SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: Icon(Icons.clear_all_outlined),
                ),
              ),
            ),
          ),
          if (true) ...[
            const SizedBox(height: 16.0),
            const Center(child: Icon(Icons.info_outline)),
            const SizedBox(height: 6.0),
            Center(
              child: Text(AppLocalizations.of(context)!.noNotifications),
            ),
            const SizedBox(height: 16.0),
          ],
        ],
      );
}