import 'package:chat_app/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    required this.data,
    required this.controller,
    this.isPassword = false,
  });
  final String data;
  final TextEditingController controller;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword ? true : false,
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      controller: controller,
      validator: isPassword
          ? (value) {
              if (value != null && value.isNotEmpty && value.length == 6) {
                return null;
              } else {
                return "Enter 6 digit password";
              }
            }
          : (value) {
              if (value != null && value.isNotEmpty && value.contains('@')) {
                return null;
              } else {
                return "Enter valid email";
              }
            },
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          label: Text(data),
          labelStyle: TextStyle(
              color: ColorConstants.black,
              fontWeight: FontWeight.w600,
              fontSize: 20)),
    );
  }
}
