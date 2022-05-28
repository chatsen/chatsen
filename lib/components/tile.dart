import 'package:flutter/material.dart';

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

  // Padding(
  // padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  // child: Row(
  // children: [
  // const SizedBox(
  // width: 40.0,
  // height: 40.0,
  // child: Icon(Icons.person_add_alt),
  // ),
  // const SizedBox(width: 16.0),
  // Text(AppLocalizations.of(context)!.addAnotherAccount),
  // ],
  // ),
  // ),

  // Material(
  //   borderRadius: BorderRadius.circular(24.0),
  //   clipBehavior: Clip.antiAlias,
  //   child: SizedBox(
  //     width: active ? 40.0 : 36.0,
  //     height: active ? 40.0 : 36.0,
  //     child: twitchAccount.userData != null
  //         ? Ink.image(
  //             image: NetworkImage(twitchAccount.userData!.avatarUrl),
  //             fit: BoxFit.cover,
  //           )
  //         : const Icon(Icons.question_mark_outlined),
  //   ),
  // ),

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
