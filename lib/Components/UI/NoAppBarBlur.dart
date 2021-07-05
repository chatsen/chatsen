import 'package:flutter/material.dart';

import 'WidgetBlur.dart';

class NoAppBarBlur extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) => WidgetBlur(
        child: SizedBox.expand(),
      );

  @override
  Size get preferredSize => Size.fromHeight(0.0);
}
