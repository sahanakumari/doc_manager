import 'package:flutter/material.dart';

class SFormInput extends StatelessWidget {
  final TextEditingController? controller;
  final bool? enabled;
  final bool? forcedBorder;
  final String? label;
  final String? hint;
  final Widget? suffixIcon;

  const SFormInput(
      {Key? key,
      this.controller,
      this.enabled,
      this.label,
      this.hint,
      this.suffixIcon,
      this.forcedBorder = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints(maxWidth: 24),
          disabledBorder: (forcedBorder ?? false) ? null : InputBorder.none,
        ),
      ),
    );
  }
}

class SFormSelect extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final dynamic value;
  final bool? enabled;
  final String? label;
  final String? hint;
  final Widget? suffixIcon;
  final void Function(dynamic value)? onChanged;

  const SFormSelect(
      {Key? key,
      this.enabled,
      this.label,
      this.hint,
      this.suffixIcon,
      required this.items,
      this.value,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: DropdownButtonFormField(
        icon: suffixIcon,
        value: value,
        onChanged: (enabled ?? true) ? onChanged : null,
        isExpanded: true,
        hint: Text(hint ?? "selectOption"),
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          disabledBorder: InputBorder.none,
        ),
        items: items,
      ),
    );
  }
}
