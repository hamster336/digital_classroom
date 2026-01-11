import 'package:mobile_app/classroom/model/classroom.dart';
import 'package:mobile_app/user/models/student.dart';
import 'package:mobile_app/user/models/teacher.dart';

class ClassroomRepo {
  final classes = [
    Classroom(
      id: '1',
      name: 'Sem 1, BCT',
      faculty: 'Engineering',
      createdAt: DateTime(2026, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      isActive: true,
    ),
    Classroom(
      id: '2',
      name: 'Sem 2, BCT',
      faculty: 'Engineering',
      createdAt: DateTime(2026, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      isActive: false,
    ),

    Classroom(
      id: '3',
      name: 'Sem 3, BCT',
      faculty: 'Engineering',
      createdAt: DateTime(2025, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      isActive: true,
    ),
    Classroom(
      id: '4',
      name: 'Sem 1, BBA',
      faculty: 'Management',
      createdAt: DateTime(2026, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      isActive: true,
    ),
    Classroom(
      id: '5',
      name: 'Sem 1, BCE',
      faculty: 'Engineering',
      createdAt: DateTime(2026, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      isActive: true,
    ),
    Classroom(
      id: '6',
      name: 'Sem 3, BCE',
      faculty: 'Engineering',
      createdAt: DateTime(2025, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      isActive: true,
    ),
    Classroom(
      id: '7',
      name: 'Sem 5, BCE',
      faculty: 'Engineering',
      createdAt: DateTime(2024, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
      isActive: false,
    ),
    Classroom(
      id: '8',
      name: 'Sem 6, BCE',
      faculty: 'Engineering',
      createdAt: DateTime(2024, 06, 13, 10, 00),
      startYear: 2026,
      endYear: 2026,
      isActive: true,
    ),
    Classroom(
      id: '9',
      name: 'Sem 7, BCE',
      faculty: 'Engineering',
      createdAt: DateTime(2023, 01, 01, 10, 00),
      startYear: 2026,
      endYear: 2026,
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
