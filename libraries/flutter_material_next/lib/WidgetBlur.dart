import 'dart:ui';

import 'package:flutter/material.dart';

class WidgetBlur extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final double blur;

  const WidgetBlur({
    required this.child,
    this.borderRadius,
    this.blur = 10.0,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(0.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blur,
                sigmaY: blur,
              ),
              child: Material(
                color: Colors.transparent,
                child: child,
              ),
            ),
          ),
        ],
      );
}
