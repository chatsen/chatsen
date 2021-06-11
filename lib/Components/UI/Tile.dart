import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool dense;

  const Tile({
    Key? key,
    this.onTap,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.dense = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          iconTheme: Theme.of(context).iconTheme.copyWith(
                color: Theme.of(context).hintColor,
              ),
          textTheme: Theme.of(context).textTheme.copyWith(
                subtitle2: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
        ),
        child: Builder(
          builder: (context) => InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(dense ? 8.0 : 16.0),
              child: Row(
                children: [
                  if (leading != null) ...[
                    leading!,
                    SizedBox(width: dense ? 8.0 : 16.0),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    SizedBox(width: dense ? 8.0 : 16.0),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      );
}
