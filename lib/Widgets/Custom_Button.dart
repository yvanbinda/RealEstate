import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomButton extends StatelessWidget {
  final Widget? widget;
  final void Function()? onTap;
  final BorderRadius? borderRadius;
  const CustomButton({
    super.key,
    this.widget,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 7.h,
        decoration: BoxDecoration(
          color: Color(0xFF2F60E3),
          borderRadius: borderRadius ?? BorderRadius.circular(30),
        ),
        child: Center(child: widget),
      ),
    );
  }
}