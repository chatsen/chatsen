import 'package:flutter/material.dart';

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
          borderRadius: BorderRadius.circular(64.0),
          side: value ? BorderSide.none : BorderSide(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.33), width: 2),
        ),
        color: value ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground.withOpacity(0.25 / 2.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(64.0),
          onTap: () => onChanged(!value),
          child: SizedBox(
            width: (48.0 + 64.0) / 2.0,
            height: 32.0,
            child: AnimatedAlign(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              duration: const Duration(milliseconds: 100),
              curve: Curves.decelerate,
              child: AnimatedContainer(
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                width: value ? 24.0 : 16.0,
                height: value ? 24.0 : 16.0,
                margin: const EdgeInsets.only(right: 4.0, left: 8.0),
                decoration: BoxDecoration(color: value ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.onBackground.withOpacity(0.33), shape: BoxShape.circle),
              ),
            ),
          ),
        ),
      );
}
