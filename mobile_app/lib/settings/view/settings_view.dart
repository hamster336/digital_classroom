import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/auth/bloc/auth_bloc.dart';
import 'package:mobile_app/auth/view/change_password_screen.dart';
import 'package:mobile_app/shared/custom_widgets.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(title: const Text('Settings')),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              SizedBox(height: size.height * 0.01),
              // account and privacy section
              const Text(
                'ACCOUNT & PRIVACY',
                style: TextStyle(color: Colors.black54),
              ),

              // change password
              SizedBox(
                width: size.width,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: CustomWidgets.navigateSettings(
                      'Change Password',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordScreen(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.025),

              // about sections
              const Text('ABOUT', style: TextStyle(color: Colors.black54)),

              SizedBox(
                width: size.width,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        CustomWidgets.navigateSettings('Help & Support', () {}),

                        Divider(),

                        // app version
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              // app version
                              const Text(
                                'App version',
                                style: TextStyle(fontSize: 20),
                              ),
                              const Text(
                                'v1.0',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.03),

              // logout button
              InkWell(
                onTap: _logOut,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.05),
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(Icons.delete_rounded, color: Colors.red, size: 25),
                      const SizedBox(width: 5),
                      const Text(
                        'Log out',
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // logout method
  void _logOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out', style: TextStyle(color: Colors.red)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.pop(context);
            },
            child: const Text('Ok', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
