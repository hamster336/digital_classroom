import 'package:flutter/material.dart';
import 'package:mobile_app/shared/custom_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Reset Password')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: .min,
              children: [
                SizedBox(height: size.height * 0.01),

                const Text(
                  'Enter your email address. You will be sent an OTP if the email is valid and an account with that email exists.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),

                SizedBox(height: size.height * 0.01),

                CustomWidgets.customTextField(
                  controller: controller,
                  label: 'Email',
                  obscureText: false,
                ),

                SizedBox(height: size.height * 0.05),

                CustomWidgets.customButton(size, 'Send OTP', () => _resetPsw()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetPsw() {
    final text = controller.text.trim();

    if (text.isEmpty) {
      CustomWidgets.customAltertBox(
        context,
        'Field cannot be left empty.',
        () {},
      );
      return;
    }

    
  }
}
