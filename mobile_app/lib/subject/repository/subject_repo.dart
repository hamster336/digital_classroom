import 'package:mobile_app/subject/model/subject.dart';
import 'package:mobile_app/user/models/student.dart';
import 'package:mobile_app/user/models/teacher.dart';

class SubjectRepo {
  final list = [
    Subject(id: 'sub1', name: 'Math', classId: 'cl1', teacherId: 'ID01'),
    Subject(id: 'sub2', name: 'Optics', classId: 'cl1', teacherId: 'ID01'),
    Subject(id: 'sub3', name: 'English', classId: 'cl1', teacherId: 'ID01'),
    Subject(
      id: 'sub4',
      name: 'Applied Mechanics',
      classId: 'cl2',
      teacherId: 'ID01',
    ),
    Subject(
      id: 'sub5',
      name: 'Numerical Methods',
      classId: 'cl7',
      teacherId: 'ID01',
    ),
    Subject(
      id: 'sub8',
      name: 'Electric Circuit Theory',
      classId: 'cl3',
      teacherId: 'ID01',
    ),
    Subject(id: 'sub6', name: 'AI', classId: 'cl8', teacherId: 'ID01'),
    Subject(id: 'sub9', name: 'Communication System', classId: 'cl8', teacherId: 'ID02'),
    Subject(id: 'sub7', name: 'DBMS', classId: 'cl8', teacherId: 'ID03'),
    Subject(id: 'sub10', name: 'Research Methodology', classId: 'cl8', teacherId: 'ID04'),
    Subject(id: 'sub11', name: 'Engineering Economics', classId: 'cl8', teacherId: 'ID05'),
    Subject(id: 'sub12', name: 'Project & Organization Management', classId: 'cl8', teacherId: 'ID06'),
  ];

  List<Subject> teachersSubjects(Teacher teacher) {
    return list.where((s) => teacher.subjectIds.contains(s.id)).toList();
  }

  List<Subject> studentsSubjects(Student student) {
    return list.where((s) => student.subjectIds.contains(s.id)).toList();
  }
}
