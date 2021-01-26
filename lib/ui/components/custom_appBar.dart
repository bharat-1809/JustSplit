import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Widget child;
  final double expandableHeight;
  final Widget leading;
  final Widget title;
  final List<Widget> actions;
  CustomAppBar({
    @required this.height,
    @required this.expandableHeight,
    @required this.child,
    this.leading,
    this.title,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      stretch: true,
      automaticallyImplyLeading: false,
      expandedHeight: expandableHeight,
      leading: leading,
      actions: actions,
      title: title,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground],
        background: child,
      ),
    );
  }
}
