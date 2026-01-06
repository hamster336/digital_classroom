import 'package:flutter/material.dart';
import 'package:mobile_app/model/custom_widgets.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _pushNoti = true;
  bool _asgnmntReminder = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              SizedBox(height: size.height * 0.01),

              // notification settings section
              const Text(
                'NOTIFICATION',
                style: TextStyle(color: Colors.black54),
              ),

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
                        // push notification
                        CustomWidgets.toggleSetting(
                          'Push Notification',
                          _pushNoti,
                          (value) => setState(() => _pushNoti = value),
                        ),

                        Divider(),

                        // assignment reminders
                        CustomWidgets.toggleSetting(
                          'Assignment Reminders',
                          _asgnmntReminder,
                          (value) => setState(() => _asgnmntReminder = value),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.025),

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
                      () {},
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

  void _logOut() {}
}
