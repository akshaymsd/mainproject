import 'package:flutter/material.dart';
import 'package:mainproject/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? texColor;

  const CustomButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.color,
      this.texColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: color ?? KButtonColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)) // Button color
          ),
      child: Text(
        text,
        style: TextStyle(color: texColor ?? Colors.white),
      ),
    );
  }
}
