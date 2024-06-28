import 'package:flutter/material.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class SelectDropDownButton<T> extends StatelessWidget {
  final Color containerColor;
  final Color? borderColor;

  final T? value;
  final String hinText;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>>? items;

  const SelectDropDownButton({
    super.key,
    required this.containerColor,
    this.value,
    required this.onChanged,
    required this.hinText,
    this.items,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: containerColor,
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          borderRadius: BorderRadius.circular(24),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Style.black,
          ),
          items: items,
          padding: const EdgeInsets.only(left: 8),
          hint: Container(
            margin: const EdgeInsets.only(left: 8),
            child: Text(hinText),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
