import 'package:flutter/material.dart';

///Main Appbar used in multiple pages.
class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = Colors.red;
  final Text title;

  /// you can add more fields that meet your needs

  const MainAppbar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: this.title,
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0x00ffffff),
        iconTheme: IconThemeData(
          color: Theme.of(context).accentColor,
        ));
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
