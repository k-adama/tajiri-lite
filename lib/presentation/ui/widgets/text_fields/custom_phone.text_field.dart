import 'package:flutter/material.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class CustomPhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const CustomPhoneTextField(
      {super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Style.brandColor500,
      style: Style.interNormal(
        size: 13,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        focusedBorder: null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Style.grey100,
            width: .5,
          ),
        ),
      ),
    );
  }
}
