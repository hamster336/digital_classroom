import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/app/auth_gate.dart';
import 'package:mobile_app/assignments/bloc/assignment_bloc.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.dart';
import 'package:mobile_app/auth/bloc/auth_bloc.dart';
import 'package:mobile_app/auth/repository/auth_repo.dart';
import 'package:mobile_app/home/bloc/upcoming_bloc.dart';
import 'package:mobile_app/notices/bloc/notice_bloc.dart';
import 'package:mobile_app/notices/repository/notice_repo.dart';

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
    final size = MediaQuery.of(context).size;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AssignmentRepo()),
        RepositoryProvider(create: (_) => NoticeRepo()),
        RepositoryProvider(create: (_) => AuthRepo()),
      ],
      child: MultiBlocProvider(
        // injecting blocs
        providers: [
          BlocProvider(
            create: (context) =>
                NoticeBloc(context.read<NoticeRepo>())..add(LoadNotices()),
          ),
          BlocProvider(
            create: (context) =>
                AssignmentBloc(context.read<AssignmentRepo>())
                  ..add(LoadAssignments()),
          ),
          BlocProvider(
            create: (context) => UpcomingBloc(
              assignRepo: context.read<AssignmentRepo>(),
              noticeRepo: context.read<NoticeRepo>(),
            )..add(LoadUpcomingEvents()),
          ),
          BlocProvider(
            create: (context) => AuthBloc()..add(AuthCheckRequested()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Academia',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: .fromSeed(seedColor: Colors.white),
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
                letterSpacing: 0.5,
              ),
              leadingWidth: size.width * 0.075,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, // text & icon
              ),
            ),
          ),
          home: const AuthGate(),
          // home: const LoginScreen(),
        ),
      ),
    );
  }
}
