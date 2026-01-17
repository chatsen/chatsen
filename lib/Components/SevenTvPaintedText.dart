import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Cosmetics/SevenTvCosmeticsCubit.dart';

class SevenTvPaintedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final SevenTvPaint paint;

  const SevenTvPaintedText({
    Key? key,
    required this.text,
    required this.style,
    required this.paint,
  }) : super(key: key);

  @override
  State<SevenTvPaintedText> createState() => _SevenTvPaintedTextState();
}

class _SevenTvPaintedTextState extends State<SevenTvPaintedText> {
  ImageStream? _stream;
  ImageStreamListener? _listener;
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _resolveImageIfNeeded();
  }

  @override
  void didUpdateWidget(covariant SevenTvPaintedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.paint.imageUrl != widget.paint.imageUrl ||
        oldWidget.paint.function != widget.paint.function) {
      _stopListening();
      _image = null;
      _resolveImageIfNeeded();
    }
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  void _stopListening() {
    if (_stream != null && _listener != null) {
      _stream!.removeListener(_listener!);
    }
    _stream = null;
    _listener = null;
  }

  void _resolveImageIfNeeded() {
    if (widget.paint.function != 'URL') return;
    final url = widget.paint.imageUrl;
    if (url == null || url.isEmpty) return;

    final provider = CachedNetworkImageProvider(url);
    final stream = provider.resolve(const ImageConfiguration());
    _stream = stream;
    _listener = ImageStreamListener((info, _) {
      if (!mounted) return;
      setState(() {
        _image = info.image;
      });
    });
    stream.addListener(_listener!);
  }

  @override
  Widget build(BuildContext context) {
    final paint = widget.paint;

    Widget textWidget = _buildPaintedText(paint);

    if (paint.dropShadows.isNotEmpty) {
      textWidget = _applyDropShadows(textWidget, paint.dropShadows);
    }

    return textWidget;
  }

  Widget _buildPaintedText(SevenTvPaint paint) {
    if (paint.function == 'URL') {
      if (_image == null) {
        return Text(widget.text, style: widget.style);
      }

      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => _imageShaderCover(_image!, bounds),
        child: Text(
          widget.text,
          style: widget.style.copyWith(color: Colors.white),
        ),
      );
    }

    if (paint.function == 'GRADIENT' || paint.function == 'LINEAR_GRADIENT') {
      if (paint.stops.isEmpty) return Text(widget.text, style: widget.style);
      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => _createLinearGradientShader(bounds, paint),
        child: Text(
          widget.text,
          style: widget.style.copyWith(color: Colors.white),
        ),
      );
    }

    if (paint.function == 'RADIAL_GRADIENT') {
      if (paint.stops.isEmpty) return Text(widget.text, style: widget.style);
      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => _createRadialGradientShader(bounds, paint),
        child: Text(
          widget.text,
          style: widget.style.copyWith(color: Colors.white),
        ),
      );
    }

    return Text(widget.text, style: widget.style);
  }

  Widget _applyDropShadows(Widget child, List<SevenTvDropShadow> shadows) {
    return Stack(
      children: [
        for (final shadow in shadows.where((s) => s.radius > 0))
          Transform.translate(
            offset: Offset(shadow.xOffset, shadow.yOffset),
            child: Text(
              widget.text,
              style: widget.style.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.fill
                  ..color = shadow.color
                  ..maskFilter = MaskFilter.blur(
                    BlurStyle.normal,
                    shadow.radius / 2,
                  ),
              ),
            ),
          ),
        child,
      ],
    );
  }

  ui.Shader _imageShaderCover(ui.Image image, Rect bounds) {
    final iw = image.width.toDouble();
    final ih = image.height.toDouble();
    final bw = bounds.width;
    final bh = bounds.height;

    final scale = max(bw / iw, bh / ih);
    final tx = (bw - iw * scale) / 2.0;
    final ty = (bh - ih * scale) / 2.0;

    final matrix = Float64List(16);
    matrix[0] = scale;
    matrix[5] = scale;
    matrix[10] = 1.0;
    matrix[15] = 1.0;
    matrix[12] = tx;
    matrix[13] = ty;

    return ui.ImageShader(
      image,
      widget.paint.repeat ? ui.TileMode.repeated : ui.TileMode.clamp,
      widget.paint.repeat ? ui.TileMode.repeated : ui.TileMode.clamp,
      matrix,
    );
  }

  ui.Shader _createLinearGradientShader(Rect rect, SevenTvPaint paint) {
    final angle = paint.angle ?? 90.0;
    final stops = paint.stops;
    final repeat = paint.repeat;

    final angleStep = (angle ~/ 90) % 4;

    Offset startPoint;
    Offset endPoint;

    switch (angleStep) {
      case 0:
        startPoint = rect.bottomLeft;
        endPoint = rect.topRight;
        break;
      case 1:
        startPoint = rect.topLeft;
        endPoint = rect.bottomRight;
        break;
      case 2:
        startPoint = rect.topRight;
        endPoint = rect.bottomLeft;
        break;
      case 3:
        startPoint = rect.bottomRight;
        endPoint = rect.topLeft;
        break;
      default:
        startPoint = rect.bottomLeft;
        endPoint = rect.topRight;
    }

    final center = rect.center;
    final gradientAxisAngle = (90.0 - angle) * pi / 180.0;
    final colorAxisAngle = -angle * pi / 180.0;

    final gradientStart = _lineIntersection(
      center,
      gradientAxisAngle,
      startPoint,
      colorAxisAngle,
    );
    final gradientEnd = _lineIntersection(
      center,
      gradientAxisAngle,
      endPoint,
      colorAxisAngle,
    );

    if (gradientStart == null || gradientEnd == null) {
      return ui.Gradient.linear(
        rect.centerLeft,
        rect.centerRight,
        stops.map((s) => s.color).toList(),
        stops.map((s) => s.position).toList(),
      );
    }

    Offset finalStart = gradientStart;
    Offset finalEnd = gradientEnd;

    if (repeat && stops.isNotEmpty) {
      finalStart =
          _lerpOffset(gradientStart, gradientEnd, stops.first.position);
      finalEnd = _lerpOffset(gradientStart, gradientEnd, stops.last.position);
    }

    final colors = stops.map((s) => s.color).toList();
    final positions = repeat
        ? stops.map((s) => _offsetRepeatingPosition(s.position, stops)).toList()
        : stops.map((s) => s.position).toList();

    return ui.Gradient.linear(
      finalStart,
      finalEnd,
      colors,
      positions,
      repeat ? TileMode.repeated : TileMode.clamp,
    );
  }

  ui.Shader _createRadialGradientShader(Rect rect, SevenTvPaint paint) {
    final stops = paint.stops;
    final repeat = paint.repeat;

    final cx = rect.left + rect.width / 2;
    final cy = rect.top + rect.height / 2;
    final center = Offset(cx, cy);

    var radius = max(rect.width, rect.height) / 2;
    if (repeat && stops.isNotEmpty) {
      radius = radius * stops.last.position;
    }

    final colors = stops.map((s) => s.color).toList();
    final positions = repeat
        ? stops.map((s) => _offsetRepeatingPosition(s.position, stops)).toList()
        : stops.map((s) => s.position).toList();

    return ui.Gradient.radial(
      center,
      radius,
      colors,
      positions,
      repeat ? TileMode.repeated : TileMode.clamp,
    );
  }

  Offset? _lineIntersection(Offset p1, double a1, Offset p2, double a2) {
    final d1 = Offset(cos(a1), -sin(a1));
    final d2 = Offset(cos(a2), -sin(a2));

    final cross = d1.dx * d2.dy - d1.dy * d2.dx;
    if (cross.abs() < 1e-10) return null;

    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final t = (dx * d2.dy - dy * d2.dx) / cross;

    return Offset(p1.dx + t * d1.dx, p1.dy + t * d1.dy);
  }

  Offset _lerpOffset(Offset a, Offset b, double t) {
    return Offset(a.dx + (b.dx - a.dx) * t, a.dy + (b.dy - a.dy) * t);
  }

  double _offsetRepeatingPosition(double pos, List<SevenTvPaintStop> stops) {
    if (stops.isEmpty) return pos;
    final first = stops.first.position;
    final last = stops.last.position;
    final range = last - first;
    if (range.abs() < 1e-10) return 0.0;
    return (pos - first) / range;
  }
}
