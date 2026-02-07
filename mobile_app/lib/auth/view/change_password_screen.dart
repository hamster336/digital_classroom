import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/auth/bloc/auth_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPswController = TextEditingController();
  final newPswController = TextEditingController();
  final confirmPswController = TextEditingController();
  BuildContext? dialogContext;

  @override
  void dispose() {
    oldPswController.dispose();
    newPswController.dispose();
    confirmPswController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Change Password')),
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (dialogContext != null && Navigator.canPop(dialogContext!)) {
              Navigator.pop(dialogContext!);
              dialogContext = null;
            }

            if (state is AuthFailure) {
              CustomWidgets.customAltertBox(context, state.message, () {});
            }

            if (state is PasswordChangeSuccess) {
              CustomWidgets.customAltertBox(
                context,
                'Password changed successfully.',
                () => Navigator.pop(context),
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: .min,
              children: [
                SizedBox(height: size.height * 0.05),

                CustomWidgets.customTextField(
                  controller: oldPswController,
                  label: 'Old Password',
                  obscureText: false,
                ),
                SizedBox(height: size.height * 0.01),
                CustomWidgets.customTextField(
                  controller: newPswController,
                  label: 'New Password',
                  obscureText: false,
                ),
                SizedBox(height: size.height * 0.01),
                CustomWidgets.customTextField(
                  controller: confirmPswController,
                  label: 'Confirm Password',
                  obscureText: false,
                ),
                SizedBox(height: size.height * 0.05),

                CustomWidgets.customButton(
                  size,
                  'Change Password',
                  () async => _change(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // change password method
  Future<void> _change() async {
    final oldPsw = oldPswController.text.trim();
    final newPsw = newPswController.text.trim();
    final confirmPsw = confirmPswController.text.trim();

    // show dialog for empty fields
    if (oldPsw.isEmpty || newPsw.isEmpty || confirmPsw.isEmpty) {
      CustomWidgets.customAltertBox(context, 'Fields cannot be empty.', () {});
      return;
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        dialogContext = context;
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF2AB3AA)),
        );
      },
    );

    context.read<AuthBloc>().add(
      ChangePassword(
        oldPassword: oldPsw,
        newPassword: newPsw,
        confirmPassword: confirmPsw,
      ),
    );
  }
}
