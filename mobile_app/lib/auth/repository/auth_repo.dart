import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/user/models/app_user.dart';
import 'package:mobile_app/user/models/student.dart';
import 'package:mobile_app/user/models/teacher.dart';

class AuthRepo {
  // dummy null user
  // AppUser? user;

  // dummy student data
  // AppUser? user = Student(
  //   id: 'stud1',
  //   name: 'Jane Doe',
  //   email: 'janedoe@dummy.com',
  //   createdAt: DateTime(2026, 01, 01),
  //   rollNumber: '143',
  //   classId: '1',
  //   subjectIds: [],
  //   role: UserRoles.student,
  // );

  // dummy teacher data
  AppUser? user = Teacher(
    id: 'ID01',
    name: 'Jane Doe',
    email: 'jane.doe@example.com',
    createdAt: DateTime(2025, 12, 25),
    empId: 'Rg01',
    subjectIds: [],
    classIds: [],
    role: UserRoles.teacher,
  );

  AppUser? get getUser => user;
}
