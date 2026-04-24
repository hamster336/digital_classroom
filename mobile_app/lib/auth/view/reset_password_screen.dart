import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/app/auth_gate.dart';
import 'package:mobile_app/auth/bloc/auth_bloc.dart';
import 'package:mobile_app/auth/bloc/password_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final pswController = TextEditingController();

  @override
  void dispose() {
    pswController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      backgroundColor: Colors.white,
      body: BlocListener<PasswordBloc, PasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordFailure) {
            CustomWidgets.customAltertBox(context, state.message, () {});
          }

          if (state is ResetPasswordSuccess) {
            CustomWidgets.customAltertBox(
              context,
              'Password has been reset.',
              () {
                context.read<AuthBloc>().add(CheckAuth());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthGate()),
                );
              },
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
                  mainAxisSize: .min,
                  children: [
                    SizedBox(height: size.height * 0.01),

                    Row(
                      children: [
                        const Text(
                          'Enter a new password.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.02),

                    CustomWidgets.customTextField(
                      controller: pswController,
                      label: 'New Password',
                      obscureText: false,
                    ),

                    SizedBox(height: size.height * 0.05),

                    CustomWidgets.customButton(
                      size,
                      'Reset Password',
                      () => _resetPsw(),
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

  // reset password
  void _resetPsw() {
    final password = pswController.text.trim();

    if (password.isEmpty) {
      CustomWidgets.customAltertBox(
        context,
        'Field cannot be left empty.',
        () {},
      );
      return;
    }

    context.read<PasswordBloc>().add(ResetPassword(password: password));
  }
}
