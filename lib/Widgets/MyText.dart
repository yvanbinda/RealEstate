import 'package:flutter/cupertino.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Mytext extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const Mytext({
    super.key,
    required this.text,
    this.style
  });

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 25.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
