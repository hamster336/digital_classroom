import 'package:mobile_app/classroom/model/classroom.dart';
import 'package:mobile_app/user/models/student.dart';
import 'package:mobile_app/user/models/teacher.dart';

class ClassroomRepo {
  final classes = [
    Classroom(
      id: 'cl1',
      name: 'Sem 1, BCT',
      faculty: 'Engineering',
      createdAt: DateTime(2026, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      studentCount: 45,
      isActive: true,
    ),
    Classroom(
      id: 'cl2',
      name: 'Sem 2, BCT',
      faculty: 'Engineering',
      createdAt: DateTime(2026, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      studentCount: 0,
      isActive: false,
    ),

    Classroom(
      id: 'cl3',
      name: 'Sem 3, BCT',
      faculty: 'Engineering',
      createdAt: DateTime(2025, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      studentCount: 30,
      isActive: true,
    ),
    Classroom(
      id: 'cl4',
      name: 'Sem 1, BBA',
      faculty: 'Management',
      createdAt: DateTime(2026, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      studentCount: 84,
      isActive: true,
    ),
    Classroom(
      id: 'cl5',
      name: 'Sem 1, BCE',
      faculty: 'Engineering',
      createdAt: DateTime(2026, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      studentCount: 47,
      isActive: true,
    ),
    Classroom(
      id: 'cl6',
      name: 'Sem 3, BCE',
      faculty: 'Engineering',
      createdAt: DateTime(2025, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      studentCount: 45,
      isActive: true,
    ),
    Classroom(
      id: 'cl7',
      name: 'Sem 5, BCE',
      faculty: 'Engineering',
      createdAt: DateTime(2024, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      studentCount: 0,
      isActive: false,
    ),
    Classroom(
      id: 'cl8',
      name: 'Sem 6, BCT',
      faculty: 'Engineering',
      createdAt: DateTime(2024, 06, 13, 10, 00),
      startYear: 2026,
      endYear: 2026,
      studentCount: 38,
      isActive: true,
    ),
    Classroom(
      id: 'cl9',
      name: 'Sem 7, BCT',
      faculty: 'Engineering',
      createdAt: DateTime(2023, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      studentCount: 40,
      isActive: true,
    ),
  ];

  List<Classroom> fetchClassesForTeacher(Teacher teacher) {
    return classes
        .where((c) => c.isActive && teacher.classIds.contains(c.id))
        .toList();
  }

  Classroom fetchStudentClassDetails(Student student) {
    return classes.singleWhere((c) => c.id == student.classId);
  }
}
