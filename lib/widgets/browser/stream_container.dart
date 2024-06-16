import 'package:chatsen/components/surface.dart';
import 'package:chatsen/modal/browser_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../components/modal.dart';
import '../../components/split.dart';
import '../../data/browser/browser_state.dart';
import '../../data/browser/browser_tab.dart';
import 'browser.dart';

class StreamContainer extends StatefulWidget {
  final Widget child;
  final bool theater;

  const StreamContainer({
    super.key,
    required this.child,
    this.theater = false,
  });

  @override
  State<StreamContainer> createState() => _StreamContainerState();
}

class _StreamContainerState extends State<StreamContainer> {
  bool displayTabs = false;

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
  Widget build(BuildContext context) => Stack(
        children: [
          BlocBuilder<BrowserState, List<BrowserTab>>(
            builder: (context, state) {
              if (state.isEmpty) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                return widget.child;
              }

              final mediaQuery = MediaQuery.of(context);
              bool horizontal = mediaQuery.size.width > mediaQuery.size.height;

              final actions = [
                Padding(
                  padding: EdgeInsets.only(
                    top: horizontal ? mediaQuery.padding.top : 0.0,
                  ),
                  child: Surface(
                    borderRadius: BorderRadius.circular(32.0),
                    type: SurfaceType.transparent,
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.tab_outlined,
                        size: 16.0,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        displayTabs = !displayTabs;
                      });
                    },
                  ),
                ),
              ];

              final browser = Browser(
                showTabs: displayTabs,
              );
              if (widget.theater && horizontal) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
                return Stack(
                  children: [
                    browser,
                    CustomSplit(
                      prefixes: actions,
                      axis: Axis.horizontal,
                      initialFractions: const [0.75, 0.25],
                      children: [
                        Container(),
                        MediaQuery.removePadding(
                          context: context,
                          removeLeft: horizontal,
                          removeTop: !horizontal,
                          child: widget.child,
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              }

              return CustomSplit(
                prefixes: actions,
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
                    right: !horizontal,
                    bottom: horizontal,
                    child: browser,
                  ),
                  MediaQuery.removePadding(
                    context: context,
                    removeLeft: horizontal,
                    removeTop: !horizontal,
                    child: widget.child,
                  ),
                ],
              );
            },
          ),
          // FloatingStreamButton(),
        ],
      );
}

class FloatingStreamButton extends StatefulWidget {
  const FloatingStreamButton({
    super.key,
  });

  @override
  State<FloatingStreamButton> createState() => _FloatingStreamButtonState();
}

class _FloatingStreamButtonState extends State<FloatingStreamButton> {
  double x = 0.0;
  double y = 0.0;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final mediaQuery = MediaQuery.of(context);
        x = mediaQuery.viewPadding.left;
        y = mediaQuery.viewPadding.top;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Positioned(
      left: x.clamp(mediaQuery.viewPadding.left, mediaQuery.size.width - mediaQuery.viewPadding.right - 32.0),
      top: y.clamp(mediaQuery.viewPadding.top, mediaQuery.size.height - mediaQuery.viewPadding.bottom - 32.0),
      child: Tooltip(
        message: AppLocalizations.of(context)!.browserStreamSettings,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              x += details.delta.dx;
              y += details.delta.dy;
              x = x.clamp(mediaQuery.viewPadding.left, mediaQuery.size.width - mediaQuery.viewPadding.right - 32.0);
              y = y.clamp(mediaQuery.viewPadding.top, mediaQuery.size.height - mediaQuery.viewPadding.bottom - 32.0);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(48.0),
              color: Colors.black.withOpacity(0.25),
              child: InkWell(
                borderRadius: BorderRadius.circular(48.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.stream_outlined,
                    color: Colors.white.withOpacity(0.5),
                    size: 16.0,
                  ),
                ),
                onTap: () {
                  Modal.show(
                    context: context,
                    child: const BrowserSettingsModal(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
