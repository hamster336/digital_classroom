import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/auth/bloc/password_bloc.dart';
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: BlocListener<PasswordBloc, PasswordState>(
            listener: (context, state) {
              if (state is ChangePasswordFailure) {
                CustomWidgets.customAltertBox(context, state.message, () {});
              }

              if (state is ChangePasswordSuccess) {
                CustomWidgets.customAltertBox(
                  context,
                  'Password changed successfully.',
                  () => Navigator.pop(context),
                );
              }
            },
            child: BlocBuilder<PasswordBloc, PasswordState>(
              builder: (context, state) {
                if(state is PasswordStateLoading) {
                  return CustomWidgets.customLoader();
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: .start,
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
                      SizedBox(height: size.height * 0.01),
                      const Text(
                        '\t\tThe password must have atleast 6 characters.',
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(height: size.height * 0.05),

                      Center(
                        child: CustomWidgets.customButton(
                          size,
                          'Change Password',
                          () async => _change(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // change password method
  Future<void> _change() async {
    FocusScope.of(context).unfocus();
    final oldPsw = oldPswController.text.trim();
    final newPsw = newPswController.text.trim();
    final confirmPsw = confirmPswController.text.trim();

    // show dialog for empty fields
    if (oldPsw.isEmpty || newPsw.isEmpty || confirmPsw.isEmpty) {
      CustomWidgets.customAltertBox(context, 'Fields cannot be empty.', () {});
      return;
    }

    context.read<PasswordBloc>().add(
      ChangePassword(
        oldPassword: oldPsw,
        newPassword: newPsw,
        confirmPassword: confirmPsw,
      ),
    );
  }
}
