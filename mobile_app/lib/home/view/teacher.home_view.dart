import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/assignments/view/teacher.assignment_view.dart';
import 'package:mobile_app/classroom/bloc/classroom_bloc.dart';
import 'package:mobile_app/classroom/classroom_gate.dart';
import 'package:mobile_app/upcoming/bloc/upcoming_bloc.dart';
import 'package:mobile_app/notes/view/teacher.notes_view.dart';
import 'package:mobile_app/notices/bloc/notice_bloc.dart';
import 'package:mobile_app/schedules/view/schedules.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/user/models/teacher.dart';
import 'package:mobile_app/user/view/teacher_profile_screen.dart';

class TeacherHomeView extends StatefulWidget {
  final Teacher teacher;
  const TeacherHomeView({super.key, required this.teacher});

  @override
  State<TeacherHomeView> createState() => _TeacherHomeViewState();
}

class _TeacherHomeViewState extends State<TeacherHomeView> {
  @override
  void initState() {
    super.initState();
    context.read<ClassroomBloc>().add(LoadClasses(user: widget.teacher));
    context.read<UpcomingBloc>().add(
      LoadEvents(subjectIds: widget.teacher.subjectIds),
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
                title: const Text(
                  'Hi, Jane Doe!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                // User Role
                subtitle: const Text(
                  'Teacher',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),

                // Profile button
                trailing: IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TeacherProfileScreen(teacher: widget.teacher),
                    ),
                  ),
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                  icon: Icon(Icons.person, color: Colors.green, size: 30),
                ),
              ),
            ),
          ),

          SizedBox(height: size.height * 0.01),

          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // general information
                      Row(
                        mainAxisAlignment: .spaceEvenly,
                        children: [
                          // no of subjects
                          Expanded(
                            child: BlocBuilder<ClassroomBloc, ClassroomState>(
                              builder: (context, state) {
                                if (state is! ClassesLoaded) {
                                  return CustomWidgets.infoCard(
                                    size,
                                    0,
                                    'Classes',
                                  );
                                }

                                return CustomWidgets.infoCard(
                                  size,
                                  state.classes.length,
                                  'Classes',
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
                                  100,  // dummy data
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
                            'Manage Notes',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TeacherNotesView(),
                              ),
                            ),
                          ),
                          CustomWidgets.resrcCard(
                            size,
                            Icons.note_rounded,
                            'Assignments',
                            'Manage assignments',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ClassroomGate(
                                  onClassSelected: (context, classroom) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TeacherAssignmentView(
                                          cls: classroom,
                                          teacherId: widget.teacher.id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
                            'View timetables',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ClassroomGate(
                                  onClassSelected: (context, classroom) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            Schedules(classId: classroom.id),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          CustomWidgets.resrcCard(
                            size,
                            Icons.info,
                            'Class Details',
                            'See class details',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ClassroomGate(
                                  onClassSelected: (context, classroom) {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          CustomWidgets.showClassDetails(
                                            context,
                                            classroom,
                                          ),
                                    );
                                  },
                                ),
                              ),
                            ),
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
                          child: Center(
                            child: const Text(
                              'Loading...',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ),
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
