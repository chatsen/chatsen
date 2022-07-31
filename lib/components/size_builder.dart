import 'package:flutter/material.dart';

class SizeBuilder extends StatelessWidget {
  final ValueNotifier<Rect> notifier = ValueNotifier(const Rect.fromLTWH(0, 0, 0, 0));
  final Widget Function(BuildContext context, Rect paintBounds, Widget? child) builder;
  final Widget? child;

  SizeBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        notifier.value = (context.findRenderObject() as RenderBox).paintBounds;
      },
    );
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: builder,
      child: child,
    );
  }
}
