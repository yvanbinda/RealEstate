import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String hintext;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final TextStyle? textStyle;
  const CustomTextfield({
    super.key,
    required this.hintext,
    this.suffixIcon,
    this.prefixIcon,
    this.textStyle
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintext,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintStyle: textStyle,
          prefixStyle: textStyle,
          suffixStyle: textStyle,
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFF43464B)),
            borderRadius: BorderRadius.circular(15)
          ),
        ),
      ),
    );
  }
}
