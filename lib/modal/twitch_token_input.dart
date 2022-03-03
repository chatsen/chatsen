import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/components/separator.dart';
import 'verify_token.dart';
import '/components/modal.dart';

class TwitchTokenInputModal extends StatefulWidget {
  const TwitchTokenInputModal({
    Key? key,
  }) : super(key: key);

  @override
  State<TwitchTokenInputModal> createState() => _TwitchTokenInputModalState();
}

class _TwitchTokenInputModalState extends State<TwitchTokenInputModal> {
  late TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () async => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(24.0),
                  child: const SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Icon(Icons.close),
                  ),
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(context)!.tokenInput,
                  style: const TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  width: 40.0,
                  height: 40.0,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 32.0,
                child: Separator(axis: Axis.vertical),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();

                    Modal.show(
                      context: context,
                      child: VerifyTokenModal(
                        token: controller.text,
                        cookies: null,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.add,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}
