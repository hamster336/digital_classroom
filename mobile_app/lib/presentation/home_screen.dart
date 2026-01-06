import 'package:flutter/material.dart';
import 'package:mobile_app/model/custom_widgets.dart';
import 'package:mobile_app/model/notice.dart';
import 'package:mobile_app/model/required_enums.dart';
import 'package:mobile_app/presentation/assignment_screen.dart';
import 'package:mobile_app/presentation/notes_screen.dart';
import 'package:mobile_app/presentation/schedules.dart';
import 'package:mobile_app/presentation/user_profile.dart';
// import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                title: const Text(
                  'Hi, Jane Doe!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                subtitle: const Text(
                  // DateFormat('dd MMM yyy').format(DateTime.now()),
                  '6th Sem, BCT',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                trailing: IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserProfile()),
                  ),
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                  icon: Icon(Icons.person, color: Colors.green, size: 30),
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
                          Expanded(
                            child: CustomWidgets.infoCard(size, 6, 'Classes'),
                          ),
                          Expanded(
                            child: CustomWidgets.infoCard(
                              size,
                              12,
                              'Assignments',
                            ),
                          ),
                          Expanded(
                            child: CustomWidgets.infoCard(
                              size,
                              3,
                              'New Notices',
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
                            'Access your study notes',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotesScreen(),
                              ),
                            ),
                          ),
                          CustomWidgets.resrcCard(
                            size,
                            Icons.note_rounded,
                            'Assignments',
                            'Track your homework',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AssignmentScreen(),
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
                                builder: (_) => const Schedules(),
                              ),
                            ),
                          ),
                          CustomWidgets.resrcCard(
                            size,
                            Icons.note_alt_rounded,
                            'Resources',
                            'Learning materials',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Schedules(),
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
                          style: TextStyle(fontSize: 18),
                        ),
                      ),

                      SizedBox(height: size.height * 0.01),

                      // upcoming events cards
                      CustomWidgets.homeScrenNoticeCard(
                        Notice(
                          title: 'Research proposal submission',
                          publishedAt: DateTime(2026, 1, 5, 14, 12, 22),
                          description: 'description',
                          priority: InfoPriority.urgent,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      CustomWidgets.homeScrenNoticeCard(
                        Notice(
                          title: 'AI assignment submission',
                          publishedAt: DateTime(2026, 1, 4, 08, 56, 01),
                          description: 'description',
                          priority: InfoPriority.info,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      CustomWidgets.homeScrenNoticeCard(
                        Notice(
                          title: 'FU cup team selection',
                          publishedAt: DateTime(2026, 1, 2, 23, 55, 12),
                          description: 'description',
                          priority: InfoPriority.important,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
