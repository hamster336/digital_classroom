import 'package:flutter/material.dart';
import 'package:mobile_app/model/custom_widgets.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // username and profile section
            Container(
              width: size.width,
              height: size.longestSide * 0.17,
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
              ),
              child: SafeArea(
                bottom: false,
                child: ListTile(
                  title: const Text(
                    'Hi, Jane Doe!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  subtitle: const Text(
                    // DateFormat('dd MMM yyy').format(DateTime.now()),
                    '01 Jan 2026',
                    style: TextStyle(color: Colors.white, fontSize: 20),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                children: [
                  // general information
                  Row(
                    mainAxisAlignment: .spaceEvenly,
                    children: [
                      Expanded(
                        child: CustomWidgets.infoCard(size, 6, 'Classes'),
                      ),
                      Expanded(
                        child: CustomWidgets.infoCard(size, 12, 'Assignments'),
                      ),
                      Expanded(
                        child: CustomWidgets.infoCard(size, 2, 'New Notices'),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.015),

                  // learning materials and resources
                  Center(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
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
                          Icons.note_alt_rounded,
                          'Assignments',
                          'Track your homework',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AssignmentScreen(),
                            ),
                          ),
                        ),
                        CustomWidgets.resrcCard(
                          size,
                          Icons.note_alt_rounded,
                          'Schedules',
                          'View your timetable',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Schedules(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.015),

                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text(
                      'Upcoming',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
