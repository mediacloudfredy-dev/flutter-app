import 'package:flutter/material.dart';

class AppSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hint;

  const AppSearchField({super.key, required this.onChanged, this.hint = 'Search notes...'});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onChanged: onChanged,
    );
  }
}
