import 'package:flutter/material.dart';

class EcliniqAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EcliniqAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.centerTitle,
    this.primary = true,
  });

  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final bool? centerTitle;
  final bool primary;

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: leading,
      title: title,
      actions: actions,
      centerTitle: centerTitle,
      primary: primary,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
