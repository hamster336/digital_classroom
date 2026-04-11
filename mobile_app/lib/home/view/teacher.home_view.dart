import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/assignments/view/teacher_view/teacher.assignment_view.dart';
import 'package:mobile_app/classroom/bloc/classroom_bloc.dart';
import 'package:mobile_app/classroom/classroom_gate.dart';
import 'package:mobile_app/home/bloc/teachers_dashboard_bloc.dart';
import 'package:mobile_app/notices/notice_bloc/notice_bloc.dart';
import 'package:mobile_app/notices/unread_count_bloc/unread_count_bloc.dart';
import 'package:mobile_app/shared/custom_methods.dart';
import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/upcoming/bloc/upcoming_bloc.dart';
import 'package:mobile_app/notes/view/teacher.notes_view.dart';
import 'package:mobile_app/schedules/view/schedules_view.dart';
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
    // class details
    context.read<ClassroomBloc>().add(LoadClasses(user: widget.teacher));
    // subjects
    context.read<SubjectBloc>().add(
      LoadSubjects(subjectIds: widget.teacher.subjectIds),
    );
    // upcoming events
    context.read<UpcomingBloc>().add(
      LoadEvents(subjectIds: widget.teacher.subjectIds),
    );
    // unread notices bloc
    context.read<UnreadCountBloc>().add(
      LoadUnreadCount(lastChecked: widget.teacher.lastCheckedNotices),
    );
    // actve assignment count
    context.read<DashboardBloc>().add(
      LoadActiveAssignmentCount(teacherId: widget.teacher.id),
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
          final upcomingBloc = context.read<UpcomingBloc>();
          final dashBloc = context.read<DashboardBloc>();
          final currentNoticeFilter = (noticeBloc.state is NoticeLoaded)
              ? (noticeBloc.state as NoticeLoaded).filter
              : NoticeFilter.all;

          // notices
          futures.add(
            noticeBloc.stream.firstWhere(
              (state) => state is NoticeLoaded || state is NoticeLoadingError,
            ),
          );
          // active assignments
          futures.add(
            dashBloc.stream.firstWhere(
              (state) =>
                  state is DashboardLoaded || state is DashboardLoadingError,
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
          // refresh active assignments
          dashBloc.add(LoadActiveAssignmentCount(teacherId: widget.teacher.id));
          //refresh upcoming events
          upcomingBloc.add(
            RefreshEvents(subjectIds: widget.teacher.subjectIds),
          );

          await Future.wait(futures);
        },

        child: MultiBlocListener(
          listeners: [
            BlocListener<ClassroomBloc, ClassroomState>(
              listener: (context, state) {
                if (state is ClassError) {
                  CustomWidgets.customAltertBox(
                    context,
                    'Class Loading Error: ${state.message}',
                    () {},
                  );
                }
              },
            ),
            BlocListener<SubjectBloc, SubjectState>(
              listener: (context, state) {
                if (state is SubjectError) {
                  CustomWidgets.customAltertBox(
                    context,
                    'Subject Loading Error: ${state.message}',
                    () {},
                  );
                }
              },
            ),
            BlocListener<UpcomingBloc, UpcomingState>(
              listener: (context, state) {
                if (state is UpcomingError) {
                  CustomWidgets.customAltertBox(
                    context,
                    'Upcomging Event Loading Error: ${state.message}',
                    () {},
                  );
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
                      'Hi, ${CustomMethods.firstName(widget.teacher.name)}!',
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
                    trailing: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TeacherProfileScreen(teacher: widget.teacher),
                        ),
                      ),
                      child: CircleAvatar(
                        radius: size.width * 0.06,
                        backgroundColor: Colors.white,
                        backgroundImage: (widget.teacher.avatarURL != null)
                            ? NetworkImage(widget.teacher.avatarURL!)
                            : null,
                        child: (widget.teacher.avatarURL == null)
                            ? Icon(
                                Icons.person_rounded,
                                size: size.width * 0.1,
                                color: Color(0xFF2AB3AA),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.01),

              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsetsGeometry.symmetric(
                        horizontal: 10,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // general information
                          Row(
                            mainAxisAlignment: .spaceEvenly,
                            children: [
                              // no of subjects
                              Expanded(
                                child:
                                    BlocBuilder<ClassroomBloc, ClassroomState>(
                                      builder: (context, state) {
                                        final String classCount =
                                            (state is ClassesLoaded)
                                            ? state.classes.length.toString()
                                            : '-';

                                        return CustomWidgets.infoCard(
                                          size,
                                          classCount,
                                          'Classes',
                                        );
                                      },
                                    ),
                              ),

                              // number of active assignments (that have not passed due date)
                              Expanded(
                                child:
                                    BlocBuilder<DashboardBloc, DashboardState>(
                                      builder: (context, state) {
                                        final String subjectCount =
                                            (state is DashboardLoaded)
                                            ? state.activeAssignmentCount
                                                  .toString()
                                            : '-';

                                        return CustomWidgets.infoCard(
                                          size,
                                          subjectCount,
                                          'Assignments',
                                        );
                                      },
                                    ),
                              ),

                              // unread notices
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
                              // notes
                              CustomWidgets.resrcCard(
                                size,
                                Icons.note_alt_rounded,
                                'Notes',
                                'Manage Notes',
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ClassroomGate(
                                      onClassSelected: (context, classroom) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => TeacherNotesView(
                                              teacher: widget.teacher,
                                              classId: classroom.id,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              // assignments
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
                                            builder: (_) =>
                                                TeacherAssignmentView(
                                                  cls: classroom,
                                                  teacher: widget.teacher,
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
                              // schedules
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
                                            builder: (_) => SchedulesView(
                                              classId: classroom.id,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              // class details
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

                    // upcoming event cards
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
