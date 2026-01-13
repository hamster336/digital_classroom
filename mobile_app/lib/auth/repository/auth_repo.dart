// ignore_for_file: unused_import

import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/user/models/app_user.dart';
import 'package:mobile_app/user/models/student.dart';
import 'package:mobile_app/user/models/teacher.dart';

class AuthRepo {
  // dummy null user
  // AppUser? user;

  // dummy student data
  // AppUser? get getUser => Student(
  //   id: 'stud1',
  //   name: 'Jane Doe',
  //   email: 'janedoe@dummy.com',
  //   createdAt: DateTime(2026, 01, 01),
  //   rollNumber: '143',
  //   classId: 'cl8',
  //   subjectIds: ['sub6', 'sub7', 'sub9', 'sub10', 'sub11', 'sub12'],
  //   role: UserRoles.student,
  // );

  // dummy teacher data
  AppUser? get getUser => Teacher(
    id: 'T1',
    name: 'Jane Doe',
    email: 'jane.doe@example.com',
    createdAt: DateTime(2025, 12, 25),
    empId: 'Emp01',
    subjectIds: [],
    classIds: ['cl1', 'cl2', 'cl3', 'cl5', 'cl6', 'cl8'],
    role: UserRoles.teacher,
  );
}
