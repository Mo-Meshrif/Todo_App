class DrawerItemModel {
  final String title;
  final String icon;
  final double size;
  final bool rotate;
  final void Function() onTap;

  DrawerItemModel({
    required this.title,
    required this.icon,
    required this.size,
    required this.rotate,
    required this.onTap,
  });
}
