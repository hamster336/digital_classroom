import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/assignments/student_assignments/bloc/student.assignment_bloc.dart';
import 'package:mobile_app/classroom/bloc/classroom_bloc.dart';
import 'package:mobile_app/notices/notice_bloc/notice_bloc.dart';
import 'package:mobile_app/notices/unread_count_bloc/unread_count_bloc.dart';
import 'package:mobile_app/shared/custom_methods.dart';
import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/upcoming/bloc/upcoming_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/assignments/view/student_view/student.assignment_view.dart';
import 'package:mobile_app/notes/view/student.notes_view.dart';
import 'package:mobile_app/schedules/view/schedules_view.dart';
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
    // load number of new notices
    context.read<UnreadCountBloc>().add(
      LoadUnreadCount(lastChecked: widget.student.lastCheckedNotices),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        displacement: 100,
        onRefresh: () async {
          final futures = <Future>[];
          final noticeBloc = context.read<NoticeBloc>();
          final assgnmentBloc = context.read<StudentsAssignmentBloc>();
          final upcomingBloc = context.read<UpcomingBloc>();
          final currentNoticeFilter = (noticeBloc.state is NoticeLoaded)
              ? (noticeBloc.state as NoticeLoaded).filter
              : NoticeFilter.all;

          // notices
          futures.add(
            noticeBloc.stream.firstWhere(
              (state) => state is NoticeLoaded || state is NoticeLoadingError,
            ),
          );
          // assignments
          futures.add(
            assgnmentBloc.stream.firstWhere(
              (state) =>
                  state is StudentAssignmentLoaded ||
                  state is StudentAssignmentLoadingError,
            ),
          );
          // events
          futures.add(
            upcomingBloc.stream.firstWhere(
              (state) => state is UpcomingLoaded || state is UpcomingError,
            ),
          );

          /// trigger refresh events
          // refresh notices
          noticeBloc.add(RefreshNotices(currentFilter: currentNoticeFilter));
          // refresh assignemnts
          assgnmentBloc.add(RefreshAssignments(student: widget.student));
          //refresh upcoming events
          upcomingBloc.add(
            RefreshEvents(subjectIds: widget.student.subjectIds),
          );

          await Future.wait(futures);
        },

        child: MultiBlocListener(
          listeners: [
            BlocListener<UpcomingBloc, UpcomingState>(
              listener: (context, state) {
                if (state is UpcomingError) {
                  CustomWidgets.customAltertBox(context, state.message, () {});
                }
              },
            ),
            BlocListener<StudentsAssignmentBloc, StudentsAssignmentState>(
              listener: (context, state) {
                if (state is StudentAssignmentLoadingError) {
                  CustomWidgets.customAltertBox(context, state.message, () {});
                }
              },
            ),
            BlocListener<ClassroomBloc, ClassroomState>(
              listener: (context, state) {
                if (state is ClassError) {
                  CustomWidgets.customAltertBox(context, state.message, () {});
                }
              },
            ),
            BlocListener<SubjectBloc, SubjectState>(
              listener: (context, state) {
                if (state is SubjectError) {
                  CustomWidgets.customAltertBox(context, state.message, () {});
                }
              },
            ),
            BlocListener<UnreadCountBloc, UnreadCountState>(
              listener: (context, state) {
                if (state is CountError) {
                  CustomWidgets.customAltertBox(context, state.message, () {});
                }
              },
            ),
          ],
          child: Column(
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
                      'Hi, ${CustomMethods.firstName(widget.student.name)}!',
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
                          (cls == null)
                              ? 'Loading...'
                              : 'Student | ${cls.name}',
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

                        return GestureDetector(
                          onTap: (cls == null)
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
                          child: CircleAvatar(
                            radius: size.width * 0.06,
                            backgroundImage: (widget.student.avatarURL != null)
                                ? NetworkImage(widget.student.avatarURL!)
                                : null,
                            child: (widget.student.avatarURL == null)
                                ? Icon(
                                    Icons.person_rounded,
                                    size: size.width * 0.1,
                                  )
                                : null,
                          ),
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
                                  final String subjectCount =
                                      (state is SubjectLoaded)
                                      ? state.subjects.length.toString()
                                      : '-';

                                  return Expanded(
                                    child: CustomWidgets.infoCard(
                                      size,
                                      subjectCount,
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
                                        final String pendingCount =
                                            (state is StudentAssignmentLoaded)
                                            ? state.pendingCount.toString()
                                            : '-';

                                        return CustomWidgets.infoCard(
                                          size,
                                          pendingCount,
                                          'Assignments',
                                        );
                                      },
                                    ),
                              ),

                              // latest notices
                              Expanded(
                                child:
                                    BlocBuilder<
                                      UnreadCountBloc,
                                      UnreadCountState
                                    >(
                                      builder: (context, state) {
                                        final String unreadNotice =
                                            (state is CountLoaded)
                                            ? state.count.toString()
                                            : '-';

                                        return CustomWidgets.infoCard(
                                          size,
                                          unreadNotice,
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
                                    builder: (_) => StudentNotesView(
                                      student: widget.student,
                                    ),
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
                                    builder: (_) => StudentAssignmentView(
                                      student: widget.student,
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
                                'View your timetable',
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SchedulesView(
                                      classId: widget.student.classId,
                                    ),
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
                              child: CustomWidgets.customLoader(),
                            ),
                          );
                        }

                        final events = state.displayEvents;

                        if (events.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: size.height * 0.02,
                                ),
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
                              return CustomWidgets.homeScreenCard(
                                events[index],
                              );
                            },
                          ),
                        );
                      },
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(height: size.height * 0.01),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
