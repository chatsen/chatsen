import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageW extends StatelessWidget {
  final String url;
  final double? scale;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool cache;

  const NetworkImageW(
    this.url, {
    Key? key,
    this.scale,
    this.width,
    this.height,
    this.fit,
    this.cache = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Image(
        // url,
        image: CachedNetworkImageProvider(
          url,
          scale: scale ?? 1.0,
          cacheKey: cache ? null : '$url:${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
        ),
        filterQuality: FilterQuality.high,
        width: width,
        height: height,
        fit: fit,
        // isAntiAlias: true,
      );
}

// placeholderFadeInDuration: Duration(microseconds: 0),
// fadeInDuration: Duration(microseconds: 0),
// fadeOutDuration: Duration(microseconds: 0),
// placeholder: (context, url) => Container(),
