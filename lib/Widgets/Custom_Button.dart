import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomButton extends StatelessWidget {
  final Text text;
  final void Function()? onTap;
  const CustomButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 7.h,
        decoration: BoxDecoration(
          color: Color(0xFF2F60E3),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(child: text),
      ),
    );
  }
}
