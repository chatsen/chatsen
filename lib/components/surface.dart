import 'package:flutter/material.dart';

enum SurfaceType {
  primary,
  secondary,
  tertiary,
  error,
}

class Surface extends StatelessWidget {
  final Widget child;
  final SurfaceType type;
  final Function()? onTap;
  final Function()? onLongPress;
  final BorderRadius? borderRadius;

  const Surface({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.type = SurfaceType.primary,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = type == SurfaceType.primary
        ? Theme.of(context).colorScheme.primaryContainer
        : type == SurfaceType.secondary
            ? Theme.of(context).colorScheme.secondaryContainer
            : type == SurfaceType.tertiary
                ? Theme.of(context).colorScheme.tertiaryContainer
                : Theme.of(context).colorScheme.errorContainer;
    final foregroundColor = type == SurfaceType.primary
        ? Theme.of(context).colorScheme.primary
        : type == SurfaceType.secondary
            ? Theme.of(context).colorScheme.secondary
            : type == SurfaceType.tertiary
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.error;

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              displayColor: foregroundColor,
              bodyColor: foregroundColor,
              decorationColor: foregroundColor,
            ),
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: foregroundColor,
            ),
      ),
      child: Material(
        borderRadius: borderRadius,
        color: backgroundColor,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          onLongPress: onLongPress,
          child: child,
        ),
      ),
    );
  }
}
