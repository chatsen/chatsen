import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Tile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? prefix;
  final Widget? suffix;
  final bool primary;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const Tile({
    super.key,
    required this.title,
    this.subtitle,
    this.prefix,
    this.suffix,
    this.primary = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Row(
            children: [
              SizedBox(width: primary ? 0.0 : 2.0),
              SizedBox(
                width: primary ? 40.0 : 36.0,
                height: primary ? 40.0 : 36.0,
                child: prefix,
              ),
              SizedBox(width: 16.0 + (primary ? 0.0 : 2.0)),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.75),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              SizedBox(width: 16.0 + (primary ? 0.0 : 2.0)),
              SizedBox(
                width: primary ? 40.0 : 36.0,
                height: primary ? 40.0 : 36.0,
                child: suffix,
              ),
              SizedBox(width: primary ? 0.0 : 2.0),
            ],
          ),
        ),
      );
}

class BoxSwitchTile extends StatelessWidget {
  final Box box;
  final String boxKey;
  final bool boxDefault;

  final String title;
  final String? subtitle;
  final Widget? prefix;
  final bool primary;
  final void Function()? onLongPress;

  const BoxSwitchTile({
    super.key,
    required this.box,
    required this.boxKey,
    required this.boxDefault,
    required this.title,
    this.subtitle,
    this.prefix,
    this.primary = false,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    bool value = (box.get(boxKey) as bool?) ?? boxDefault;
    return Tile(
      title: title,
      subtitle: subtitle,
      prefix: const Icon(Icons.history),
      suffix: Switch.adaptive(
        value: value,
        onChanged: (newValue) => box.put(boxKey, newValue),
      ),
      onTap: () => box.put(boxKey, !value),
      onLongPress: onLongPress,
    );
  }
}
