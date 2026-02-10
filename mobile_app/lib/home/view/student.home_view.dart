import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/assignments/student_assignments/bloc/student.assignment_bloc.dart';
import 'package:mobile_app/classroom/bloc/classroom_bloc.dart';
import 'package:mobile_app/upcoming/bloc/upcoming_bloc.dart';
import 'package:mobile_app/notices/bloc/notice_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/assignments/view/student_view/student.assignment_view.dart';
import 'package:mobile_app/notes/view/student.notes_view.dart';
import 'package:mobile_app/schedules/view/schedules.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/user/models/student.dart';
import 'package:mobile_app/user/view/student_profile_screen.dart';

class StudentHomeView extends StatefulWidget {
  final Student student;
  const StudentHomeView({super.key, required this.student});

  @override
  State<StudentHomeView> createState() => _StudentHomeViewState();
}

class _StudentHomeViewState extends State<StudentHomeView> {
  @override
  void initState() {
    super.initState();
    // upcoming events
    context.read<UpcomingBloc>().add(
      LoadEvents(subjectIds: widget.student.subjectIds),
    );
    // assignments
    context.read<StudentsAssignmentBloc>().add(
      LoadClassAssignments(student: widget.student),
    );
    // load class details
    context.read<ClassroomBloc>().add(LoadClasses(user: widget.student));

    // load subjects details
    context.read<SubjectBloc>().add(
      LoadSubjects(subjectIds: widget.student.subjectIds),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // username and profile section
          Container(
            width: size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF3B8D9B), Color(0xFF00FFB7)],
                begin: .topLeft,
                end: .bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: ListTile(
                // greetings with user name
                title: Text(
                  'Hi, ${widget.student.name}',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                // User Role
                subtitle: BlocBuilder<ClassroomBloc, ClassroomState>(
                  builder: (context, state) {
                    final cls = (state is ClassesLoaded)
                        ? state.classes.first
                        : null;

                    return Text(
                      (cls == null) ? 'Loading...' : 'Student | ${cls.name}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    );
                  },
                ),

                // Profile button
                trailing: BlocBuilder<ClassroomBloc, ClassroomState>(
                  builder: (context, state) {
                    final cls = (state is ClassesLoaded)
                        ? state.classes.first
                        : null;

                    return IconButton(
                      onPressed: (cls == null)
                          ? () {}
                          : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StudentProfileScreen(
                                  student: widget.student,
                                  cls: cls,
                                ),
                              ),
                            ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      icon: Icon(Icons.person, color: Colors.green, size: 30),
                    );
                  },
                ),
              ),
            ),
          ),

          SizedBox(height: size.height * 0.01),

          // rest of the UI componenets
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // general information
                      Row(
                        mainAxisAlignment: .spaceEvenly,
                        children: [
                          // no of subjects
                          BlocBuilder<SubjectBloc, SubjectState>(
                            builder: (context, state) {
                              if (state is! SubjectLoaded) {
                                return Expanded(
                                  child: CustomWidgets.infoCard(
                                    size,
                                    0,
                                    'Subjects',
                                  ),
                                );
                              }

                              return Expanded(
                                child: CustomWidgets.infoCard(
                                  size,
                                  state.subejcts.length,
                                  'Subjects',
                                ),
                              );
                            },
                          ),

                          // pending assignments
                          Expanded(
                            child:
                                BlocBuilder<
                                  StudentsAssignmentBloc,
                                  StudentsAssignmentState
                                >(
                                  builder: (context, state) {
                                    if (state is! StudentAssignmentLoaded) {
                                      return CustomWidgets.infoCard(
                                        size,
                                        0,
                                        'Assignments',
                                      );
                                    }

                                    return CustomWidgets.infoCard(
                                      size,
                                      state.pendingCount,
                                      'Assignments',
                                    );
                                  },
                                ),
                          ),

                          // latest notices
                          Expanded(
                            child: BlocBuilder<NoticeBloc, NoticeState>(
                              builder: (context, state) {
                                if (state is! NoticeLoaded) {
                                  return CustomWidgets.infoCard(
                                    size,
                                    0,
                                    'New Notices',
                                  );
                                }

                                return CustomWidgets.infoCard(
                                  size,
                                  100,
                                  'New Notices',
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: size.height * 0.015),

                      // learning materials and resources
                      Row(
                        mainAxisAlignment: .spaceEvenly,
                        crossAxisAlignment: .start,
                        children: [
                          CustomWidgets.resrcCard(
                            size,
                            Icons.note_alt_rounded,
                            'Notes',
                            'Access your study materials',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StudentNotesView(),
                              ),
                            ),
                          ),
                          CustomWidgets.resrcCard(
                            size,
                            Icons.note_rounded,
                            'Assignments',
                            'Track your all homework',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StudentAssignmentView(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: .spaceEvenly,
                        crossAxisAlignment: .start,
                        children: [
                          CustomWidgets.resrcCard(
                            size,
                            Icons.blur_linear_rounded,
                            'Schedules',
                            'View your timetable',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    Schedules(classId: widget.student.classId),
                              ),
                            ),
                          ),
                          BlocBuilder<ClassroomBloc, ClassroomState>(
                            builder: (context, state) {
                              final cls = (state is ClassesLoaded)
                                  ? state.classes.first
                                  : null;

                              return CustomWidgets.resrcCard(
                                size,
                                Icons.info,
                                'Class Info',
                                'See class details',
                                (cls == null)
                                    ? () {}
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              CustomWidgets.showClassDetails(
                                                context,
                                                cls,
                                              ),
                                        );
                                      },
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.015),

                      // upcoming events text
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: const Text(
                          'Upcoming',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ]),
                  ),
                ),

                // upcoming events cards
                BlocBuilder<UpcomingBloc, UpcomingState>(
                  builder: (context, state) {
                    if (state is! UpcomingLoaded) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: size.height * 0.02),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      );
                    }

                    final events = state.displayEvents;

                    if (events.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: size.height * 0.02),
                            child: const Text(
                              'No upcoming events',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: events.length,
                        (context, index) {
                          return CustomWidgets.homeScreenCard(events[index]);
                        },
                      ),
                    );
                  },
                ),

                SliverToBoxAdapter(child: SizedBox(height: size.height * 0.01)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
