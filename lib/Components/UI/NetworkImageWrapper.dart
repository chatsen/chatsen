import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageW extends StatelessWidget {
  final String url;
  final double? scale;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const NetworkImageW(
    this.url, {
    Key? key,
    this.scale,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Image(
        // url,
        image: CachedNetworkImageProvider(
          url,
          scale: scale ?? 1.0,
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
