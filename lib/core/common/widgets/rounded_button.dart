import 'package:education_app/core/res/colors.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.onPressed,
    required this.label,
    super.key,
    this.buttonColor,
    this.labelColor,
  });
  final Color? buttonColor;
  final Color? labelColor;
  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? Colours.primaryColour,
        foregroundColor: labelColor ?? Colors.white,
        minimumSize: const Size(double.maxFinite, 50),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
