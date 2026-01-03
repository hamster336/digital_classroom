import 'package:flutter/material.dart';
import 'package:mobile_app/model/custom_widgets.dart';
import 'package:mobile_app/presentation/assignment_screen.dart';
import 'package:mobile_app/presentation/notes_screen.dart';
import 'package:mobile_app/presentation/schedules.dart';
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
            // username and menu section
            Container(
              width: size.width,
              height: size.height * 0.17,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Color(0xFF3B8D9B), Color(0xFF00FFB7)],
                  begin: .topLeft,
                  end: .bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
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
                    onPressed: () {},
                    icon: Icon(
                      Icons.menu_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.03),

            // Notice section
            Container(
              width: size.width * 0.9,
              height: size.height * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                gradient: LinearGradient(
                  colors: <Color>[Color(0xFF3B8D9B), Color(0xFF00FFB7)],
                  begin: .topLeft,
                  end: .bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(2.5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: ListTile(
                  title: const Text('Notices', style: TextStyle(fontSize: 30)),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.05),

            // notes, assignments and schedules
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: .spaceBetween,
              children: [
                CustomWidgets.homeScreenCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotesScreen()),
                  ),
                  imageAsset: 'assets/icons/book.png',
                  title: 'Notes',
                  size: size,
                ),
                CustomWidgets.homeScreenCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AssignmentScreen()),
                  ),
                  imageAsset: 'assets/icons/assignment.png',
                  title: 'Assignments',
                  size: size,
                ),
                CustomWidgets.homeScreenCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Schedules()),
                  ),
                  imageAsset: 'assets/icons/schedule.png',
                  title: 'Schedules',
                  size: size,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
