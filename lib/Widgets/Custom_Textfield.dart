import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String hintext;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final TextStyle? textStyle;
  final TextEditingController? controller;
  final bool obscureText;
  final void Function(String)? onChanged;
  final BorderSide? borderSide;
  final bool? filled;
  final Color? fillColor;

  const CustomTextfield({
    super.key,
    required this.hintext,
    this.suffixIcon,
    this.prefixIcon,
    this.textStyle,
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.borderSide,
    this.filled,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintext,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintStyle: textStyle,
          prefixStyle: textStyle,
          suffixStyle: textStyle,
          border: OutlineInputBorder(
            borderSide: borderSide ?? BorderSide(width: 2, color: Color(0xFF43464B)),
            borderRadius: BorderRadius.circular(15),
          ),
          filled: filled,
          fillColor: fillColor,
        ),
      ),
    );
  }
}