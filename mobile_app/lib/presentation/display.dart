import 'package:flutter/material.dart';
import 'package:mobile_app/presentation/home_screen.dart';
import 'package:mobile_app/presentation/settings.dart';
import 'package:mobile_app/presentation/user_profile.dart';

class Display extends StatefulWidget {
  const Display({super.key});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  int currentPageIndex = 0;

  final List<Widget> pages = const [HomeScreen(), UserProfile(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: pages[currentPageIndex],
      body: IndexedStack(index: currentPageIndex, children: pages),

      // bottomNavigationBar: NavigationBar(
      //   onDestinationSelected: (value) {
      //     setState(() => currentPageIndex = value);
      //   },
      //   selectedIndex: currentPageIndex,
      //   destinations: [
      //     NavigationDestination(
      //       selectedIcon: Icon(Icons.home_outlined, size: 30),
      //       icon: Icon(Icons.home, size: 30),
      //       label: 'Home',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.person, size: 30),
      //       selectedIcon: Icon(Icons.person_outline, size: 28),
      //       label: 'Profile',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.settings, size: 30),
      //       selectedIcon: Icon(Icons.settings_outlined, size: 30),
      //       label: 'Settings',
      //     ),
      //   ],
      //   labelTextStyle: WidgetStateProperty.all(TextStyle(fontSize: 18)),
      //   elevation: 3,
      //   indicatorColor: null,
      // ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (value) => setState(() => currentPageIndex = value),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
