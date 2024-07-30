import 'package:flutter/material.dart';

class OutlineBorderedPickDateAndTimeComponent extends StatelessWidget {
  final TextEditingController? dateTimeController;
  final String? labelText;
  final VoidCallback? onTap;
  final Widget? iconData;
  final bool readonly;
  final bool? isGrey;

  const OutlineBorderedPickDateAndTimeComponent(
      {super.key,
      required this.labelText,
      this.dateTimeController,
      this.onTap,
      this.iconData,
      this.readonly = false,
      this.isGrey});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(
        controller: dateTimeController,
        style: TextStyle(
          fontSize: 12,
          color: isGrey == true ? const Color(0xff787A7D) : null,
        ),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: iconData,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 20,
          ),
          suffixIconConstraints: const BoxConstraints(
            maxWidth: 24,
            maxHeight: 24,
          ),
          contentPadding: EdgeInsets.zero,
          isDense: true,
          labelStyle: const TextStyle(
            fontSize: 12,
            height: 0.4,
          ),
        ),
        readOnly: readonly,
        onTap: onTap,
      ),
    );
  }
}
