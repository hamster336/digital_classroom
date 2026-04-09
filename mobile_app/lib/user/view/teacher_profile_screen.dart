import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/user/models/teacher.dart';

class TeacherProfileScreen extends StatelessWidget {
  final Teacher teacher;
  const TeacherProfileScreen({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF2AB3AA),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.35,
              decoration: BoxDecoration(
                color: Color(0xFF2AB3AA),

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
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 12,
                          // spreadRadius: 1,
                          offset: Offset(2, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: size.width * 0.19,

                      backgroundImage: (teacher.avatarURL != null)
                          ? NetworkImage(teacher.avatarURL!)
                          : null,
                      child: (teacher.avatarURL == null)
                          ? Icon(Icons.person_rounded, size: size.width * 0.2)
                          : null,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    teacher.name,
                    style: TextStyle(
                      fontSize: size.width * 0.075,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 94, 204, 197),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          offset: Offset(1, 3),
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    child: Text(
                      'Teacher',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.01),
            CustomWidgets.userInfoTiles(
              'assets/images/email.png',
              'Email',
              teacher.email,
            ),
            Divider(),
            CustomWidgets.userInfoTiles(
              'assets/images/id.png',
              'Employee ID',
              teacher.empId,
            ),
            Divider(),
            CustomWidgets.userInfoTiles(
              'assets/images/shake.png',
              'Since',
              DateFormat('dd MMM y').format(teacher.createdAt.toLocal()),
            ),
          ],
        ),
      ),
    );
  }
}
