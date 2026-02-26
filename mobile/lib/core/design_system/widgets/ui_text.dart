import 'package:flutter/material.dart';
import 'package:ilia_users/core/design_system/theme/app_colors.dart';

class UIText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  const UIText.header(this.text, {super.key})
    : fontSize = 24,
      fontWeight = FontWeight.bold,
      color = AppColors.textPrimary,
      textAlign = TextAlign.start;

  const UIText.body(
    this.text, {
    super.key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign = TextAlign.start,
  });

  const UIText.error(this.text, {super.key})
    : fontSize = 13,
      fontWeight = FontWeight.w500,
      color = AppColors.error,
      textAlign = TextAlign.center;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: 1.2,
      ),
    );
  }
}
