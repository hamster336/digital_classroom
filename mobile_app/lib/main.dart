import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minor_project/presentation/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.green),
          fontFamily: 'Afacad',
          appBarTheme: AppBarThemeData(
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              // textStyle: TextStyle(fontFamily: 'Afacad'),
              foregroundColor: Colors.black, // text & icon
            ),
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
