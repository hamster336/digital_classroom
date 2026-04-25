import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/auth/bloc/password_bloc.dart';
import 'package:mobile_app/auth/view/verify_otp_screen.dart';
import 'package:mobile_app/shared/custom_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Forgot Password')),
      body: BlocListener<PasswordBloc, PasswordState>(
        listener: (context, state) {
          if (state is RequestOTPFailure) {
            CustomWidgets.customAltertBox(context, state.message, () {});
          }

          if (state is RequestOTPSuccess) {
            CustomWidgets.customAltertBox(
              context,
              'An otp has been sent to your email address.',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      VerifyOtpScreen(email: emailController.text.trim()),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<PasswordBloc, PasswordState>(
          builder: (context, state) {
            if (state is PasswordStateLoading) {
              return CustomWidgets.customLoader();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisSize: .min,
                  children: [
                    SizedBox(height: size.height * 0.01),

                    const Text(
                      'Enter your email address. You will be sent an OTP if the email is valid and an account with that email exists.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    CustomWidgets.customTextField(
                      controller: emailController,
                      label: 'Email',
                      obscureText: false,
                    ),

                    SizedBox(height: size.height * 0.05),

                    CustomWidgets.customButton(
                      size,
                      'Send OTP',
                      () => _requestOTP(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _requestOTP() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      CustomWidgets.customAltertBox(
        context,
        'Field cannot be left empty.',
        () {},
      );
      return;
    }

    context.read<PasswordBloc>().add(RequestOTP(email: email));
  }
}
