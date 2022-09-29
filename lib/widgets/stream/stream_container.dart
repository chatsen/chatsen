import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.theater = true,
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
          if (state.isEmpty) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            return child;
          }

          final mediaQuery = MediaQuery.of(context);
          bool horizontal = mediaQuery.size.width > mediaQuery.size.height;
          final browser = Browser(
            key: const ValueKey('stream-player'),
            urls: state,
          );
          if (theater && horizontal) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
            return Stack(
              children: [
                browser,
                Split(
                  axis: Axis.horizontal,
                  initialFractions: [0.75, 0.25],
                  children: [
                    Container(),
                    MediaQuery.removePadding(
                      context: context,
                      removeLeft: horizontal,
                      removeTop: !horizontal,
                      child: child,
                    ),
                  ],
                ),
              ],
            );
          } else {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          }

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
                child: browser,
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
