import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/app/auth_gate.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.impl.dart';
import 'package:mobile_app/auth/bloc/auth_bloc.dart';
import 'package:mobile_app/auth/bloc/password_bloc.dart';
import 'package:mobile_app/auth/repository/auth_repo_impl.dart';
import 'package:mobile_app/classroom/repository/classroom_repo_impl.dart';
import 'package:mobile_app/notes/repository/notes_repository_impl.dart';
import 'package:mobile_app/notices/repository/notice_repo_impl.dart';
import 'package:mobile_app/schedules/repository/schedules_repo_impl.dart';
import 'package:mobile_app/subject/repository/subject_repo_impl.dart';
import 'package:mobile_app/submission/repository/submission_repo_impl.dart';
import 'package:mobile_app/supabase/credentials/supabase.crendentials.dart';
import 'package:mobile_app/supabase/services/assignment_services.dart';
import 'package:mobile_app/supabase/services/notes_services.dart';
import 'package:mobile_app/supabase/services/notification_services.dart';
import 'package:mobile_app/supabase/services/schedule_services.dart';
import 'package:mobile_app/supabase/services/submission_services.dart';
import 'package:mobile_app/supabase/services/upcoming_services.dart';
import 'package:mobile_app/supabase/services/authetication_services.dart';
import 'package:mobile_app/supabase/services/classroom_services.dart';
import 'package:mobile_app/supabase/services/notice_services.dart';
import 'package:mobile_app/supabase/services/students_services.dart';
import 'package:mobile_app/supabase/services/subject_services.dart';
import 'package:mobile_app/supabase/services/teachers_services.dart';
import 'package:mobile_app/supabase/services/user_services.dart';
import 'package:mobile_app/upcoming/repository/upcoming_repo_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.requestPermission();

  await NotificationService().init();

  await sb.Supabase.initialize(
    url: SupabaseCredentials.APIURL,
    anonKey: SupabaseCredentials.APIKEY,
  );
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
        // auth repo
        RepositoryProvider(
          create: (_) => AuthRepoImpl(
            authService: AuthenticationServices(
              client: SupabaseCredentials.client,
            ),
            userService: UserServices(client: SupabaseCredentials.client),
            studentService: StudentsServices(
              client: SupabaseCredentials.client,
            ),
            teacherService: TeachersServices(
              client: SupabaseCredentials.client,
            ),
          ),
        ),
        // classroom repo
        RepositoryProvider(
          create: (_) => ClassroomRepoImpl(
            service: ClassroomServices(client: SupabaseCredentials.client),
          ),
        ),
        // subject repo
        RepositoryProvider(
          create: (_) => SubjectRepoImpl(
            service: SubjectServices(client: SupabaseCredentials.client),
          ),
        ),
        // Notice repo
        RepositoryProvider(
          create: (_) => NoticeRepoImpl(
            noticeService: NoticeServices(client: SupabaseCredentials.client),
            studentsService: StudentsServices(
              client: SupabaseCredentials.client,
            ),
            teachersService: TeachersServices(
              client: SupabaseCredentials.client,
            ),
          ),
        ),
        // upcoming repo
        RepositoryProvider(
          create: (_) => UpcomingRepoImpl(
            service: UpcomingServices(client: SupabaseCredentials.client),
          ),
        ),
        // assignment repo
        RepositoryProvider(
          create: (_) => AssignmentRepoImpl(
            services: AssignmentServices(client: SupabaseCredentials.client),
          ),
        ),
        // submission repo
        RepositoryProvider(
          create: (_) => SubmissionRepoImpl(
            subServices: SubmissionServices(client: SupabaseCredentials.client),
            studentServices: StudentsServices(
              client: SupabaseCredentials.client,
            ),
          ),
        ),
        // notes repo
        RepositoryProvider(
          create: (context) => NotesRepositoryImpl(
            services: NotesServices(client: SupabaseCredentials.client),
          ),
        ),
        // schedules repo
        RepositoryProvider(
          create: (context) => SchedulesRepoImpl(
            services: ScheduleServices(client: SupabaseCredentials.client),
          ),
        ),
      ],

      child: MultiBlocProvider(
        providers: [
          // other blocs are injected in auth gate so they are rebuild after every login attempt
          // auth bloc
          BlocProvider(
            create: (context) =>
                AuthBloc(context.read<AuthRepoImpl>())..add(CheckAuth()),
          ),
          // reset password bloc
          BlocProvider(
            create: (context) => PasswordBloc(context.read<AuthRepoImpl>()),
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
                fontSize: 25,
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
        ),
      ),
    );
  }
}
