import 'package:flutter/material.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class SelectDropdownComponent<T> extends StatefulWidget {
  final T value;
  final Function(T?)? onChanged;
  final List<T> items;
  final String Function(T) itemAsString;

  const SelectDropdownComponent({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    required this.itemAsString,
  });

  @override
  State<SelectDropdownComponent<T>> createState() =>
      _SelectDropdownComponentState<T>();
}

class _SelectDropdownComponentState<T>
    extends State<SelectDropdownComponent<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Style.black,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: widget.value,
          onChanged: widget.onChanged,
          items: widget.items.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(
                widget.itemAsString(value),
                style: const TextStyle(color: Style.white),
              ),
            );
          }).toList(),
          dropdownColor: Colors.black,
          style: const TextStyle(color: Style.white),
        ),
      ),
    );
  }
}
