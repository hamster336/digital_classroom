import 'package:flutter/material.dart';
import 'package:mobile_app/presentation/home_screen.dart';
import 'package:mobile_app/presentation/notices_screen.dart';
import 'package:mobile_app/presentation/settings.dart';

class Display extends StatefulWidget {
  const Display({super.key});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  int currentPageIndex = 0;

  final List<Widget> pages = const [HomeScreen(), NoticesScreen(), Settings()];

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      // body: pages[currentPageIndex],
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            },
          ),
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(builder: (_) => const NoticesScreen());
            },
          ),
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(builder: (_) => const Settings());
            },
          ),
        ],
      ),

      // bottom navigation Bar
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() => currentPageIndex = value);
        },
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home_filled,
              size: 30,
              color: Color(0xFF3B8D9B),
            ),
            icon: Icon(Icons.home_filled, size: 30),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_rounded, size: 30),
            selectedIcon: Icon(
              Icons.campaign_rounded,
              size: 28,
              color: Color(0xFF3B8D9B),
            ),
            label: 'Notices',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings, size: 30),
            selectedIcon: Icon(
              Icons.settings,
              size: 30,
              color: Color(0xFF3B8D9B),
            ),
            label: 'Settings',
          ),
        ],
        labelTextStyle: WidgetStateProperty.all(TextStyle(fontSize: 16)),
        elevation: 10,
        indicatorColor: Colors.transparent,
        // backgroundColor: Colors.white,
      ),
    );
  }
}
