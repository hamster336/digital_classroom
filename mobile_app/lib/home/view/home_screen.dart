import 'package:flutter/material.dart';
import 'package:mobile_app/auth/view/login_screen.dart';
import 'package:mobile_app/home/view/student.home_view.dart';
import 'package:mobile_app/home/view/teacher.home_view.dart';
import 'package:mobile_app/user/models/app_user.dart';
import 'package:mobile_app/user/models/student.dart';
import 'package:mobile_app/user/models/teacher.dart';

class HomeScreen extends StatelessWidget {
  final AppUser user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final currentUser = user;

    // decide the view based on the role
    if (currentUser is Student) {
      return StudentHomeView(student: currentUser);
    }

    if (currentUser is Teacher) {
      return TeacherHomeView(teacher: currentUser);
    }

    return LoginScreen();
  }
}
