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

  // home screen cards
  static Widget homeScreenCard({
    required VoidCallback onTap,
    required String imageAsset,
    required String title,
    required Size size,
  }) {
    return SizedBox(
      width: size.width * 0.43,
      child: Card(
        elevation: 2,
        child: ListTile(
          onTap: onTap,
          title: Image(
            image: AssetImage(imageAsset),
            // width: size.width * 0.1,
            height: size.width * 0.12,
          ),
          subtitle: Center(child: Text(title, style: TextStyle(fontSize: 20))),
        ),
      ),
    );
  }
}
