import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? errorText;
  final TextInputType? input;
  final Widget ? suffixIcon;
  final int ? maxLines;
  final int ? minLines;
  final bool ? obscureText;
  final Color ? borderColor;
  String? Function(String?)? validator;

  final bool ? isEnabled;

   CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.maxLines,
    this.minLines,
    this.input,
    this.errorText,
    this.suffixIcon,
    this.obscureText,
    this.borderColor,
    this.validator,
    this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide:  BorderSide(
        color: borderColor?? Colors.white,
      ),
    );
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: input,
      obscureText: obscureText??false,
      enabled: isEnabled,
      maxLines: maxLines??1,
      minLines:  minLines,
      decoration: InputDecoration(
          hintText: hintText,
          
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          errorText: errorText,
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(color: Colors.grey.shade400,fontWeight: FontWeight.w400),


          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: Colors.red))),
    );
  }
}