import 'package:flutter/material.dart';

class Modal extends StatelessWidget {
  final Widget child;
  final Clip clipBehavior;

  const Modal({
    Key? key,
    required this.child,
    this.clipBehavior = Clip.antiAlias,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0) + MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Color.alphaBlend(Theme.of(context).colorScheme.onSurface.withOpacity(0.075), Theme.of(context).colorScheme.surface),
              clipBehavior: clipBehavior,
              borderRadius: BorderRadius.circular(8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 1024.0,
                  maxHeight: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.vertical) * 0.8,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required Widget child,
    Clip clipBehavior = Clip.antiAlias,
    bool enableDrag = true,
  }) async =>
      await showModalBottomSheet(
        context: context,
        enableDrag: enableDrag,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Modal(
            clipBehavior: clipBehavior,
            child: child,
          );
        },
      );
}
