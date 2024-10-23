import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'mytext.dart';
import 'responsive.dart';

class InkWellButton extends StatefulWidget {
  final String text;
  final Function() onPressed;
  const InkWellButton({super.key, required this.text, required this.onPressed});

  @override
  State<InkWellButton> createState() => _InkWellButtonState();
}

class _InkWellButtonState extends State<InkWellButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57,
      width: Responsive.isDesktop(context) || Responsive.isDesktopLarge(context)
          ? 342
          : 240,
      decoration: BoxDecoration(
        color: AppColors.primarygreen,
        borderRadius: BorderRadius.circular(60),
      ),
      child: InkWell(
        onTap: () {
          widget.onPressed();
        },
        child: Center(
          child: HeadText(
            text: widget.text,
            textColor: Colors.white,
            textSize: 18,
          ),
        ),
      ),
    );
  }
}
