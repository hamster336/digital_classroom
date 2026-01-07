import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/notices/bloc/notice_bloc.dart';
import 'package:mobile_app/app/app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // injecting blocs
      providers: [BlocProvider(create: (context) => NoticeBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          fontFamily: 'Afacad',
          appBarTheme: AppBarThemeData(
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontFamily: 'Afacad',
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, // text & icon
            ),
          ),
        ),
        home: const AppShell(),
        // home: const LoginScreen(),
      ),
    );
  }
}
