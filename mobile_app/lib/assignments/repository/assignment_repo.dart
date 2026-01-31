import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/shared/required_enums.dart';

class AssignmentRepo {
  final _list = [
    Assignment(
      id: 'assign1',
      title: 'AI lab report',
      description:
          'All the students are expected to submit their lab report on AI by 10th of January.',
      issuedAt: DateTime(2026, 01, 06, 12, 23),
      dueDate: DateTime(2026, 01, 10, 08, 00),
      priority: AssignmentPriority.medium,
      classId: 'cl8',
      teacherId: 'T1',
      subjectId: 'sub6',
    ),
    Assignment(
      id: 'assign2',
      title: 'Minor Project Proposal submission',
      description:
          'All the students are expected to submit minor project proposal by 6th of January to the Library of School of Engineering.',
      issuedAt: DateTime(2025, 12, 25, 10, 00),
      dueDate: DateTime(2026, 01, 06, 15, 00),
      priority: AssignmentPriority.urgent,
      classId: 'cl8',
      teacherId: 'T2',
    ),
    Assignment(
      id: 'assign3',
      title: 'Economics Numericals',
      description:
          'I will provide some passed years question papers from different universities. Students will have to solve all the numerical questions that are covered in your syllabus and submit them by 01 Feb.',
      issuedAt: DateTime(2026, 01, 02, 18, 47),
      dueDate: DateTime(2026, 02, 01, 14, 30),
      priority: AssignmentPriority.normal,
      classId: 'cl8',
      teacherId: 'T3',
      subjectId: 'sub11',
    ),
    Assignment(
      id: 'assign4',
      title: 'DBMS lab report',
      description:
          'All the students are expected to submit their lab report on DBMS by 5th of January.',
      issuedAt: DateTime(2025, 12, 25, 13, 10),
      dueDate: DateTime(2026, 01, 5, 15, 00),
      priority: AssignmentPriority.normal,
      classId: 'cl8',
      teacherId: 'T4',
      subjectId: 'sub7',
    ),
    Assignment(
      id: 'assign5',
      title: 'CS lab report',
      description:
          'All the students are expected to submit their lab report on Communication system by 5th of February.',
      issuedAt: DateTime(2026, 01, 10, 13, 10),
      dueDate: DateTime(2026, 02, 5, 15, 00),
      priority: AssignmentPriority.medium,
      classId: 'cl8',
      teacherId: 'T5',
      subjectId: 'sub9',
    ),
  ];

  // fetch assignments
  List<Assignment> fetchTeachersAssignment({
    required String teacherId,
    String? classId,
  }) {
    if (classId == null) {
      return _list.where((a) => a.teacherId == teacherId).toList();
    } else {
      return _list
          .where((a) => a.classId == classId && a.teacherId == teacherId)
          .toList();
    }
  }

  List<Assignment> fetchStudentsAssignment(String classId) {
    return _list.where((a) => a.classId == classId).toList();
  }
}
