import 'package:flutter/material.dart';

enum SurfaceType {
  primary,
  secondary,
  tertiary,
  error,
  background,
  surface,
  surfaceVariant,
  transparent,
}

class Surface extends StatelessWidget {
  final Widget child;
  final SurfaceType type;
  final bool shouldClip;
  final Function()? onTap;
  final Function()? onLongPress;
  final BorderRadius? borderRadius;

  const Surface({
    super.key,
    required this.child,
    this.shouldClip = false,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.type = SurfaceType.primary,
  });

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).colorScheme.errorContainer;
    var foregroundColor = Theme.of(context).colorScheme.error;

    switch (type) {
      case SurfaceType.primary:
        backgroundColor = Theme.of(context).colorScheme.primaryContainer;
        foregroundColor = Theme.of(context).colorScheme.primary;
        break;
      case SurfaceType.secondary:
        backgroundColor = Theme.of(context).colorScheme.secondaryContainer;
        foregroundColor = Theme.of(context).colorScheme.secondary;
        break;
      case SurfaceType.tertiary:
        backgroundColor = Theme.of(context).colorScheme.tertiaryContainer;
        foregroundColor = Theme.of(context).colorScheme.tertiary;
        break;
      case SurfaceType.error:
        backgroundColor = Theme.of(context).colorScheme.errorContainer;
        foregroundColor = Theme.of(context).colorScheme.error;
        break;
      case SurfaceType.background:
        backgroundColor = Theme.of(context).colorScheme.background;
        foregroundColor = Theme.of(context).colorScheme.onBackground;
        break;
      case SurfaceType.surface:
        backgroundColor = Theme.of(context).colorScheme.surface;
        foregroundColor = Theme.of(context).colorScheme.onSurface;
        break;
      case SurfaceType.surfaceVariant:
        backgroundColor = Theme.of(context).colorScheme.surfaceVariant;
        foregroundColor = Theme.of(context).colorScheme.onSurfaceVariant;
        break;
    }

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
      child: type == SurfaceType.transparent
          ? InkWell(
              borderRadius: borderRadius,
              onTap: onTap,
              onLongPress: onLongPress,
              child: child,
            )
          : Material(
              clipBehavior: shouldClip ? Clip.antiAlias : Clip.none,
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
