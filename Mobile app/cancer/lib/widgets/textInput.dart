import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput({super.key, required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        validator: (val) => val != null ? 'This field is required' : null,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
