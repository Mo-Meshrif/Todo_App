import 'package:flutter/material.dart';
import '../../../../app/utils/color_manager.dart';

class TabHeader extends SliverPersistentHeaderDelegate {
  final List<Widget> tabs;
  final void Function(int val) onTap;
  final double maxHeight;
  final double minHeight;

  TabHeader({
    required this.tabs,
    required this.onTap,
    required this.maxHeight,
    required this.minHeight,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: ColorManager.primary,
      child: TabBar(
        onTap: onTap,
        indicatorColor: Colors.white,
        tabs: tabs,
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
