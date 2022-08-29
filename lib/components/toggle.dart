import 'package:flutter/material.dart';

const _kToggleWidth = 52.0;
const _kToggleHeight = 32.0;
const _kToggleInactiveSize = 16.0;
const _kToggleActiveSize = 24.0;
const _kTrackOpacity = 0.12;
const _kThumbOpacity = 0.38;
const _kOutlineWidth = 2.0;
const _kAnimationDuration = Duration(milliseconds: 100);
const _kAnimationCurve = Curves.decelerate;
final _kBorderRadius = BorderRadius.circular(_kToggleWidth);

class Toggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const Toggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Material(
        shape: RoundedRectangleBorder(
          borderRadius: _kBorderRadius,
          side: value ? BorderSide.none : BorderSide(color: Theme.of(context).colorScheme.onBackground.withOpacity(_kThumbOpacity), width: _kOutlineWidth),
        ),
        color: value ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground.withOpacity(_kTrackOpacity),
        child: InkWell(
          borderRadius: _kBorderRadius,
          onTap: () => onChanged(!value),
          child: SizedBox(
            width: _kToggleWidth,
            height: _kToggleHeight,
            child: AnimatedAlign(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              duration: _kAnimationDuration,
              curve: _kAnimationCurve,
              child: AnimatedContainer(
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                duration: _kAnimationDuration,
                curve: _kAnimationCurve,
                width: value ? _kToggleActiveSize : _kToggleInactiveSize,
                height: value ? _kToggleActiveSize : _kToggleInactiveSize,
                margin: const EdgeInsets.only(right: 4.0, left: 8.0),
                decoration: BoxDecoration(
                  color: value ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.onBackground.withOpacity(_kThumbOpacity),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      );
}
