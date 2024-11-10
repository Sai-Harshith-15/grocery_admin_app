import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../constants/app_colors.dart';

class RoundedTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsetsGeometry? contentPadding;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconButton? suffixIcon;
  final bool isObscured;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final Color? cursorColor;
  final bool enabled;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatter;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final Color? fillColor;
  final TextStyle? textStyle;
  final int? maxLength;
  void Function(String)? onChanged;

  RoundedTextField({
    Key? key,
    this.controller,
    this.textAlignVertical,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.isObscured = false,
    this.keyboardType,
    this.onTap,
    this.contentPadding,
    this.cursorColor,
    this.enabled = true,
    this.readOnly = false,
    this.inputFormatter,
    this.validator,
    this.errorText,
    this.fillColor,
    this.textStyle,
    this.maxLength,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor ?? AppColors.lightGrey, // Light grey background color
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        obscureText: isObscured,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatter,
        readOnly: readOnly,
        cursorColor: cursorColor ?? Colors.black, // Default cursor color
        textAlignVertical: textAlignVertical,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          hintStyle: TextStyle(
              color: AppColors.primaryBlack), // Customize hint text style
          labelStyle: TextStyle(
              color: AppColors.primaryBlack), // Customize label text style
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon,
                  color: AppColors.primaryBlack) // Customize prefix icon color
              : null,
          suffixIcon: suffixIcon,
          filled: true, // Fill background color
          fillColor: Colors
              .transparent, // Use transparent to show container background
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
          border: InputBorder.none, // Remove the border
          enabledBorder: InputBorder.none, // No border when enabled
          focusedBorder: InputBorder.none, // No border when focused
          errorBorder: InputBorder.none, // No border when error
          disabledBorder: InputBorder.none, // No border when disabled
          focusedErrorBorder:
              InputBorder.none, // No border when error is focused
        ),
        style: textStyle ??
            TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold), // Custom text style
      ),
    );
  }
}
