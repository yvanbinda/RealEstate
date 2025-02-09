import 'package:flutter/material.dart';

class GradientDivider extends StatelessWidget {
  final double height;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientDivider({
    super.key,
    this.height = 2.0,
    this.colors = const [Colors.grey, Colors.transparent],
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
        ),
      ),
    );
  }
}