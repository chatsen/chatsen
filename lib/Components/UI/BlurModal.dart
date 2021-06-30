import 'package:flutter/material.dart';
import '/Components/UI/WidgetBlur.dart';

/// [BlurModal] is a helper class that allows to easily create stylized transparent and blurred modals
class BlurModal extends StatelessWidget {
  final Widget child;

  const BlurModal({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => WidgetBlur(
        child: Material(
          color: Theme.of(context).colorScheme.surface.withAlpha(196),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Ink(height: 1.0, color: Theme.of(context).dividerColor),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Ink(
                  height: 2.0,
                  width: 48.0,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              child,
              Ink(height: 1.0, color: Theme.of(context).dividerColor),
            ],
          ),
        ),
      );

  static Future<void> show({required BuildContext context, required Widget child}) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BlurModal(child: child),
        ),
      ),
    );
  }
}
