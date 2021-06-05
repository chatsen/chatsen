import 'package:flutter/material.dart';

import 'WidgetBlur.dart';

class BottomModal extends StatelessWidget {
  final Widget child;
  final double? height;

  const BottomModal({
    required this.child,
    this.height,
  });

  static Future<PersistentBottomSheetController> push({
    required BuildContext context,
    required Widget child,
  }) async {
    return Scaffold.of(context).showBottomSheet(
      (context) => child,
      backgroundColor: Colors.transparent, //Theme.of(context).canvasColor.withAlpha(175),
    );
  }

  @override
  Widget build(BuildContext context) => WidgetBlur(
        child: Container(
          color: Theme.of(context).appBarTheme.backgroundColor!.withAlpha(96),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                height: 1.0,
              ),
              Container(
                width: 32.0,
                child: Divider(
                  thickness: 2.0,
                  height: 24.0,
                ),
              ),
              if (height != null)
                Container(
                  height: height,
                  child: child,
                ),
              if (height == null) child,
              Divider(
                height: 1.0,
              ),
            ],
          ),
        ),
      );
}
