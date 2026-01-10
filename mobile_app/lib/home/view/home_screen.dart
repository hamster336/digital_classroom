import 'package:flutter/material.dart';
import 'package:mobile_app/home/view/student.home_view.dart';
import 'package:mobile_app/home/view/teacher.home_view.dart';
import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/user/models/app_user.dart';

class HomeScreen extends StatelessWidget {
  final AppUser user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // decide the view based on the role
    return user.role == UserRoles.student
        ? const StudentHomeView()
        : const TeacherHomeView();
  }
}
