import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/split.dart';
import '../../data/browser_state.dart';
import 'browser.dart';

class StreamContainer extends StatelessWidget {
  final Widget child;
  final bool theater;

  const StreamContainer({
    super.key,
    required this.child,
    this.theater = false,
  });

  double verticalAspectRatioCalculation(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    return ((deviceSize.width + mediaQuery.viewPadding.top) * (9.0 / 16.0)) / (deviceSize.height - mediaQuery.viewPadding.vertical);
  }

  double horizontalAspectRatioCalculation(BuildContext context) {
    return 0.75;
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    return ((deviceSize.width + mediaQuery.viewPadding.top) * (9.0 / 16.0)) / (deviceSize.height - mediaQuery.viewPadding.vertical);
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<BrowserState, List<String>>(
        builder: (context, state) {
          final mediaQuery = MediaQuery.of(context);
          bool horizontal = mediaQuery.size.width > mediaQuery.size.height;
          if (state.isEmpty) return child;
          return Split(
            minSizes: const [100, 100],
            axis: horizontal ? Axis.horizontal : Axis.vertical,
            initialFractions: horizontal
                ? [
                    horizontalAspectRatioCalculation(context),
                    1.0 - horizontalAspectRatioCalculation(context),
                  ]
                : [
                    verticalAspectRatioCalculation(context),
                    1.0 - verticalAspectRatioCalculation(context),
                  ],
            children: [
              SafeArea(
                child: Browser(
                  key: const ValueKey('stream-player'),
                  urls: state,
                ),
                right: !horizontal,
                bottom: horizontal,
              ),
              MediaQuery.removePadding(
                context: context,
                removeLeft: horizontal,
                removeTop: !horizontal,
                child: child,
              ),
            ],
          );
        },
      );
}
