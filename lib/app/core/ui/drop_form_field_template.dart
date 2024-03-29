// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class DropFormFieldTemplate extends StatelessWidget {
  final String label;
  final bool readOnly;
  final Icon? suffixIcon;
  final VoidCallback? onTap;
  final void Function(String? value) onChanged;
  final List<String> items;
  final String? value;
  const DropFormFieldTemplate({
    Key? key,
    required this.label,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
    required this.onChanged,
    required this.items,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DropdownButtonFormField(
        value: value,
        onTap: onTap,
        items: items
            .map((value) => DropdownMenuItem(value: value, child: Text(value)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          label: Text(label),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
