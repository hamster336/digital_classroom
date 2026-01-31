import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/app/auth_gate.dart';
import 'package:mobile_app/assignments/student_assignments/bloc/student.assignment_bloc.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.dart';
import 'package:mobile_app/assignments/teacher_assignments/bloc/teacher.assignment_bloc.dart';
import 'package:mobile_app/auth/bloc/auth_bloc.dart';
import 'package:mobile_app/auth/repository/auth_repo_impl.dart';
import 'package:mobile_app/classroom/bloc/classroom_bloc.dart';
import 'package:mobile_app/classroom/repository/classroom_repo_impl.dart';
import 'package:mobile_app/supabase/credentials/supabase.crendentials.dart';
import 'package:mobile_app/home/bloc/upcoming_bloc.dart';
import 'package:mobile_app/notices/bloc/notice_bloc.dart';
import 'package:mobile_app/notices/repository/notice_repo.dart';
import 'package:mobile_app/supabase/services/authetication_services.dart';
import 'package:mobile_app/supabase/services/students_services.dart';
import 'package:mobile_app/supabase/services/teachers_services.dart';
import 'package:mobile_app/supabase/services/user_services.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/subject/repository/subject_repo.dart';
import 'package:mobile_app/submission/bloc/submission_bloc.dart';
import 'package:mobile_app/submission/repository/submission_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([.portraitUp]);

  await Supabase.initialize(
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

        RepositoryProvider(
          create: (_) => ClassroomRepoImpl(
            studentService: StudentsServices(
              client: SupabaseCredentials.client,
            ),
            teacherService: TeachersServices(
              client: SupabaseCredentials.client,
            ),
          ),
        ),

        RepositoryProvider(create: (_) => NoticeRepo()),
        RepositoryProvider(create: (_) => AssignmentRepo()),
        RepositoryProvider(create: (_) => SubmissionRepo()),
        RepositoryProvider(create: (_) => SubjectRepo()),
      ],
      child: MultiBlocProvider(
        // injecting blocs
        providers: [
          BlocProvider(
            create: (context) =>
                NoticeBloc(context.read<NoticeRepo>())..add(LoadNotices()),
          ),

          BlocProvider(
            create: (context) => StudentsAssignmentBloc(
              assignmentRepo: context.read<AssignmentRepo>(),
              submissionRepo: context.read<SubmissionRepo>(),
            ),
          ),
          BlocProvider(
            create: (context) =>
                TeacherAssignmentBloc(context.read<AssignmentRepo>()),
          ),

          BlocProvider(
            create: (context) => UpcomingBloc(
              assignRepo: context.read<AssignmentRepo>(),
              noticeRepo: context.read<NoticeRepo>(),
            ),
          ),

          BlocProvider(
            create: (context) => AuthBloc(context.read<AuthRepoImpl>())..add(AppStarted()),
            // ..add(AuthCheckRequested()),
          ),

          BlocProvider(
            create: (context) => SubmissionBloc(context.read<SubmissionRepo>()),
          ),

          BlocProvider(
            create: (context) => ClassroomBloc(context.read<ClassroomRepoImpl>()),
          ),
          BlocProvider(
            create: (context) => SubjectBloc(context.read<SubjectRepo>()),
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
          // home: const LoginScreen(),
        ),
      ),
    );
  }
}
