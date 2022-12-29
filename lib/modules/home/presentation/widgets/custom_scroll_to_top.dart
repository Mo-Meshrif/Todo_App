import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';

class CustomScrollToTop extends StatelessWidget {
  const CustomScrollToTop({Key? key, required this.builder}) : super(key: key);
  final Widget Function(BuildContext, ScrollViewProperties) builder;
  @override
  Widget build(BuildContext context) {
    return ScrollWrapper(
      enabledAtOffset: 300,
      promptAlignment: Alignment.bottomCenter,
      builder: builder,
    );
  }
}
