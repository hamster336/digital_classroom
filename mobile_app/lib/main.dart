import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/app/auth_gate.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.impl.dart';
import 'package:mobile_app/assignments/student_assignments/bloc/student.assignment_bloc.dart';
import 'package:mobile_app/assignments/teacher_assignments/bloc/teacher.assignment_bloc.dart';
import 'package:mobile_app/auth/bloc/auth_bloc.dart';
import 'package:mobile_app/auth/repository/auth_repo_impl.dart';
import 'package:mobile_app/classroom/bloc/classroom_bloc.dart';
import 'package:mobile_app/classroom/repository/classroom_repo_impl.dart';
import 'package:mobile_app/notes/bloc/notes_bloc.dart';
import 'package:mobile_app/notes/repository/notes_repository_impl.dart';
import 'package:mobile_app/notices/repository/notice_repo_impl.dart';
import 'package:mobile_app/notices/view/notices_screen.dart';
import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/subject/repository/subject_repo_impl.dart';
import 'package:mobile_app/submission/repository/submission_repo_impl.dart';
import 'package:mobile_app/supabase/credentials/supabase.crendentials.dart';
import 'package:mobile_app/supabase/services/assignment_services.dart';
import 'package:mobile_app/supabase/services/notes_services.dart';
import 'package:mobile_app/supabase/services/submission_services.dart';
import 'package:mobile_app/supabase/services/upcoming_services.dart';
import 'package:mobile_app/upcoming/bloc/upcoming_bloc.dart';
import 'package:mobile_app/notices/bloc/notice_bloc.dart';
import 'package:mobile_app/supabase/services/authetication_services.dart';
import 'package:mobile_app/supabase/services/classroom_services.dart';
import 'package:mobile_app/supabase/services/notice_services.dart';
import 'package:mobile_app/supabase/services/students_services.dart';
import 'package:mobile_app/supabase/services/subject_services.dart';
import 'package:mobile_app/supabase/services/teachers_services.dart';
import 'package:mobile_app/supabase/services/user_services.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/submission/bloc/submission_bloc.dart';
import 'package:mobile_app/upcoming/repository/upcoming_repo_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([.portraitUp]);

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
            service: NoticeServices(client: SupabaseCredentials.client),
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
            services: SubmissionServices(client: SupabaseCredentials.client),
          ),
        ),
        // notes repo
        RepositoryProvider(
          create: (context) => NotesRepositoryImpl(
            services: NotesServices(client: SupabaseCredentials.client),
          ),
        ),
      ],

      child: MultiBlocProvider(
        // injecting blocs
        providers: [
          // notice bloc
          BlocProvider(
            create: (context) =>
                NoticeBloc(context.read<NoticeRepoImpl>())
                  ..add(LoadNotices(currentFilter: NoticeFilter.all)),
            child: NoticesScreen(),
          ),
          // student assignment bloc
          BlocProvider(
            create: (context) => StudentsAssignmentBloc(
              assignmentRepo: context.read<AssignmentRepoImpl>(),
              submissionRepo: context.read<SubmissionRepoImpl>(),
            ),
          ),
          // teacher assignment bloc
          BlocProvider(  
            create: (context) =>
                TeacherAssignmentBloc(context.read<AssignmentRepoImpl>()),
          ),
          // upcoming bloc
          BlocProvider(
            create: (context) =>
                UpcomingBloc(repo: context.read<UpcomingRepoImpl>()),
          ),
          // auth bloc
          BlocProvider(
            create: (context) =>
                AuthBloc(context.read<AuthRepoImpl>())..add(AppStarted()),
            // ..add(AuthCheckRequested()),
          ),
          // submission bloc
          BlocProvider(
            create: (context) =>
                SubmissionBloc(context.read<SubmissionRepoImpl>()),
          ),
          // classroom bloc
          BlocProvider(
            create: (context) =>
                ClassroomBloc(context.read<ClassroomRepoImpl>()),
          ),
          // subject bloc
          BlocProvider(
            create: (context) => SubjectBloc(context.read<SubjectRepoImpl>()),
          ),
          // notes bloc
          BlocProvider(
            create: (context) => NotesBloc(context.read<NotesRepositoryImpl>()),
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
