import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/auth/bloc/auth_bloc.dart';
import 'package:mobile_app/auth/view/forgot_password_screen.dart';
import 'package:mobile_app/shared/custom_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            if (state is AuthFailure) {
              CustomWidgets.customAltertBox(context, state.message, () {});
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: const Text(
                    'Welcome\nTo Academia!',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      SizedBox(height: size.height * 0.02),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),

                      // email textField
                      CustomWidgets.customTextField(
                        controller: emailController,
                        label: 'Enter email',
                        suffixIcon: Icons.email,
                        obscureText: false,
                      ),

                      SizedBox(height: size.height * 0.02),

                      // password textField
                      CustomWidgets.customTextField(
                        controller: passController,
                        label: 'Enter password',
                        suffixIcon: Icons.password,
                        obscureText: true,
                      ),

                      // password reset and login
                      Center(
                        child: Column(
                          children: [
                            // forgot password
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ForgotPasswordScreen(),
                                ),
                              ),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),

                            SizedBox(height: size.height * 0.02),

                            // login button
                            CustomWidgets.customButton(
                              size,
                              'Login',
                              () async => await _login(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final email = emailController.text.toString();
    final psw = passController.text.toString();

    if (email.isEmpty || psw.isEmpty) {
      CustomWidgets.customAltertBox(
        context,
        'Fields cannot be left empty.',
        () {},
      );
      return;
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(child: CustomWidgets.customLoader()),
    );

    context.read<AuthBloc>().add(LoginRequested(email: email, password: psw));
    FocusScope.of(context).unfocus();
  }
}
