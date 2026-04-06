import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/home/view/home_screen.dart';
import 'package:mobile_app/notices/notice_bloc/notice_bloc.dart';
import 'package:mobile_app/notices/view/notices_screen.dart';
import 'package:mobile_app/settings/view/settings_view.dart';
import 'package:mobile_app/user/models/app_user.dart';

class AppShell extends StatefulWidget {
  final AppUser user;
  const AppShell({super.key, required this.user});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => HomeScreen(user: widget.user),
              );
            },
          ),
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(builder: (_) => const NoticesScreen());
            },
          ),
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(builder: (_) => const SettingView());
            },
          ),
        ],
      ),

      // bottom navigation Bar
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          if (currentPageIndex != value) {
            setState(() => currentPageIndex = value);

            if (value == 1) {
              context.read<NoticeBloc>().add(
                UpdateLastNoticeChecked(
                  id: widget.user.id,
                  role: widget.user.role,
                  time: DateTime.now().toUtc(),
                ),
              );
            }
          }
        },
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home_rounded,
              size: 30,
              color: Color(0xFF2AB3AA),
            ),
            icon: Icon(Icons.home_rounded, size: 30),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_rounded, size: 30),
            selectedIcon: Icon(
              Icons.campaign_rounded,
              size: 28,
              color: Color(0xFF2AB3AA),
            ),
            label: 'Notices',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings, size: 30),
            selectedIcon: Icon(
              Icons.settings,
              size: 30,
              color: Color(0xFF2AB3AA),
            ),
            label: 'Settings',
          ),
        ],
        labelTextStyle: WidgetStateProperty.all(TextStyle(fontSize: 16)),
      ),
    );
  }
}
