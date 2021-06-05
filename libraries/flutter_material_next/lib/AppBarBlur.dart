import 'package:flutter/material.dart';

import 'WidgetBlur.dart';

class AppBarBlur extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget child;

  const AppBarBlur({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => WidgetBlur(
        child: Container(
          color: Theme.of(context).appBarTheme.color!.withAlpha(196),
          child: child,
        ),
      );

  @override
  Size get preferredSize => child.preferredSize;
}
