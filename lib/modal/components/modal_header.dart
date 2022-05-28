import 'package:flutter/material.dart';

class ModalHeader extends StatelessWidget {
  final String? title;
  final Widget? trailing;
  final bool closeBackground;

  const ModalHeader({
    super.key,
    this.title,
    this.trailing,
    this.closeBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final closeButton = Tooltip(
      message: 'Close',
      child: InkWell(
        onTap: () async => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(24.0),
        child: const SizedBox(
          width: 40.0,
          height: 40.0,
          child: Icon(Icons.close),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (closeBackground)
            Material(
              borderRadius: BorderRadius.circular(24.0),
              clipBehavior: Clip.antiAlias,
              color: Theme.of(context).colorScheme.background,
              child: closeButton,
            ),
          if (!closeBackground) closeButton,
          const Spacer(),
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 24.0,
                // color: Colors.red,
              ),
            ),
            const Spacer(),
          ],
          if (trailing != null) trailing!,
          if (trailing == null)
            SizedBox(
              width: 40.0,
              height: 40.0,
              child: trailing,
            ),
        ],
      ),
    );
  }
}
