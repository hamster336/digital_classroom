import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/auth/bloc/auth_bloc.dart';
import 'package:mobile_app/auth/bloc/password_bloc.dart';
import 'package:mobile_app/auth/view/reset_password_screen.dart';
import 'package:mobile_app/shared/custom_widgets.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      backgroundColor: Colors.white,
      body: BlocListener<PasswordBloc, PasswordState>(
        listener: (context, state) {
          if (state is VerifyOTPFailure) {
            CustomWidgets.customAltertBox(context, state.message, () {});
          }

          if (state is VerifyOTPSuccess) {
            CustomWidgets.customAltertBox(
              context,
              'OTP has been verified.',
              () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
                (route) => false,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is PasswordStateLoading) {
              return Expanded(child: CustomWidgets.customLoader());
            }
            return Padding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    const Text(
                      'Enter the 6-digit OTP that has been sent to your email address.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    CustomWidgets.customTextField(
                      controller: otpController,
                      label: 'OTP',
                      obscureText: false,
                    ),

                    SizedBox(height: size.height * 0.05),

                    CustomWidgets.customButton(
                      size,
                      'Verify OTP',
                      () => _verifyOTP(),
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

  void _verifyOTP() {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      CustomWidgets.customAltertBox(
        context,
        'Field cannot be left empty.',
        () {},
      );
      return;
    }

    context.read<PasswordBloc>().add(VerifyOTP(email: widget.email, otp: otp));
  }
}
