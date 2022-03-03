import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final Axis axis;

  const Separator({
    Key? key,
    this.axis = Axis.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Container(
          height: axis == Axis.horizontal ? 1 : double.infinity,
          width: axis == Axis.vertical ? 1 : double.infinity,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.25),
        ),
      );
}
