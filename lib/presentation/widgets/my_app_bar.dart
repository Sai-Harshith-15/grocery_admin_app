import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import 'mytext.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  List<Widget>? actions;
  Widget? leading;
  bool automaticallyImplyLeading;
  MyAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      leading: widget.leading,
      iconTheme: IconThemeData(color: AppColors.background),
      backgroundColor: AppColors.primaryGreen,
      centerTitle: true,
      title: HeadText(
        text: widget.title,
        textColor: AppColors.background,
        textWeight: FontWeight.w500,
      ),
      actions: widget.actions,
    );
  }
}
