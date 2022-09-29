import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/split.dart';
import '../../data/browser_state.dart';
import 'browser.dart';

class StreamContainer extends StatelessWidget {
  final Widget child;

  const StreamContainer({
    super.key,
    required this.child,
  });

  double verticalAspectRatioCalculation(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    return (deviceSize.width * (9.0 / 16.0) + mediaQuery.viewPadding.vertical) / (deviceSize.height - mediaQuery.viewPadding.vertical);
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<BrowserState, List<String>>(
        builder: (context, state) {
          if (state.isEmpty) return child;
          return Split(
            axis: Axis.vertical,
            initialFractions: [
              verticalAspectRatioCalculation(context),
              1.0 - verticalAspectRatioCalculation(context),
            ],
            children: [
              SafeArea(
                child: Browser(
                  key: const ValueKey('stream-player'),
                  urls: state,
                ),
              ),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: child,
              ),
            ],
          );
        },
      );
}
