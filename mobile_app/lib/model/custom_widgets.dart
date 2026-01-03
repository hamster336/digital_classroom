import 'package:flutter/material.dart';

class CustomWidgets {
  // custom textFields
  static Widget customTextField({
    required TextEditingController controller,
    required String label,
    IconData? suffixIcon,
    required bool obscureText,
  }) {
    return TextField(
      decoration: InputDecoration(
        label: Text(label, style: TextStyle(fontSize: 20)),
        suffixIcon: (suffixIcon == null)
            ? null
            : Icon(
                suffixIcon,
                size: 30,
                // color: Color.fromARGB(100, 59, 141, 155),
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      obscureText: obscureText,
    );
  }

  //
  static Widget HomeScreenCard() {
    return Card();
  }
}
