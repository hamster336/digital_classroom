import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/app/app_shell.dart';
import 'package:mobile_app/auth/bloc/auth_bloc.dart';
import 'package:mobile_app/auth/view/login_screen.dart';
import 'package:mobile_app/shared/custom_widgets.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Scaffold(body: CustomWidgets.customLoader());
        }

        if (state is Authenticated) {
          return AppShell(user: state.user);
        }

        if (state is Unauthenticated || state is AuthFailure) {
          return const LoginScreen();
        }

        return const SizedBox.shrink();
      },
    );
  }
}
