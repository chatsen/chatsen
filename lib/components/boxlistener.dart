import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BoxListener<T> extends StatefulWidget {
  final Box<T> box;
  final Widget Function(BuildContext context, Box<T> box) builder;
  final List<dynamic>? keys;

  const BoxListener({
    Key? key,
    required this.box,
    required this.builder,
    this.keys,
  }) : super(key: key);

  @override
  State<BoxListener> createState() => _BoxListenerState();
}

class _BoxListenerState extends State<BoxListener> {
  late ValueListenable listenable;

  void listen() {
    setState(() {});
  }

  @override
  void initState() {
    listenable = widget.box.listenable(keys: widget.keys)..addListener(listen);
    super.initState();
  }

  @override
  void dispose() {
    listenable.removeListener(listen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, widget.box);
}
