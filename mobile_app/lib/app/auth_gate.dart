import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/app/app_shell.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.impl.dart';
import 'package:mobile_app/assignments/student_assignments/bloc/student.assignment_bloc.dart';
import 'package:mobile_app/assignments/teacher_assignments/bloc/teacher.assignment_bloc.dart';
import 'package:mobile_app/auth/bloc/auth_bloc.dart';
import 'package:mobile_app/auth/repository/auth_repo_impl.dart';
import 'package:mobile_app/auth/view/login_screen.dart';
import 'package:mobile_app/classroom/bloc/classroom_bloc.dart';
import 'package:mobile_app/classroom/repository/classroom_repo_impl.dart';
import 'package:mobile_app/home/bloc/teachers_dashboard_bloc.dart';
import 'package:mobile_app/notes/bloc/notes_bloc.dart';
import 'package:mobile_app/notes/repository/notes_repository_impl.dart';
import 'package:mobile_app/notices/repository/notice_repo_impl.dart';
import 'package:mobile_app/notices/unread_count_bloc/unread_count_bloc.dart';
import 'package:mobile_app/schedules/bloc/schedule_bloc.dart';
import 'package:mobile_app/schedules/repository/schedules_repo_impl.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/subject/repository/subject_repo_impl.dart';
import 'package:mobile_app/submission/bloc/submission_bloc.dart';
import 'package:mobile_app/submission/repository/submission_repo_impl.dart';
import 'package:mobile_app/upcoming/bloc/upcoming_bloc.dart';
import 'package:mobile_app/upcoming/repository/upcoming_repo_impl.dart';

import '../notices/notice_bloc/notice_bloc.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Scaffold(body: CustomWidgets.customLoader());
        }

        if (state is Authenticated) {
          return MultiBlocProvider(
            providers: [
              // notice bloc
              BlocProvider(
                create: (context) =>
                    NoticeBloc(context.read<NoticeRepoImpl>())
                      ..add(LoadNotices(currentFilter: NoticeFilter.all)),
              ),
              // unread notices bloc
              BlocProvider(
                create: (context) =>
                    UnreadCountBloc(context.read<NoticeRepoImpl>()),
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
                create: (context) => TeacherAssignmentBloc(
                  context.read<AssignmentRepoImpl>(),
                  context.read<SubmissionRepoImpl>(),
                ),
              ),
              // upcoming bloc
              BlocProvider(
                create: (context) =>
                    UpcomingBloc(repo: context.read<UpcomingRepoImpl>()),
              ),
              // auth bloc
              BlocProvider(
                create: (context) =>
                    AuthBloc(context.read<AuthRepoImpl>())..add(CheckAuth()),
              ),
              // classroom bloc
              BlocProvider(
                create: (context) =>
                    ClassroomBloc(context.read<ClassroomRepoImpl>()),
              ),
              // subject bloc
              BlocProvider(
                create: (context) =>
                    SubjectBloc(context.read<SubjectRepoImpl>()),
              ),
              // notes bloc
              BlocProvider(
                create: (context) =>
                    NotesBloc(context.read<NotesRepositoryImpl>()),
              ),
              // submission bloc
              BlocProvider(
                create: (context) =>
                    SubmissionBloc(context.read<SubmissionRepoImpl>()),
              ),
              // teachers dashboard bloc
              BlocProvider(
                create: (context) =>
                    DashboardBloc(context.read<AssignmentRepoImpl>()),
              ),
              // schedules bloc
              BlocProvider(
                create: (context) =>
                    ScheduleBloc(context.read<SchedulesRepoImpl>()),
              ),
            ],
            child: AppShell(user: state.user),
          );
        }

        if (state is Unauthenticated || state is AuthFailure) {
          return const LoginScreen();
        }

        return const SizedBox.shrink();
      },
    );
  }
}
