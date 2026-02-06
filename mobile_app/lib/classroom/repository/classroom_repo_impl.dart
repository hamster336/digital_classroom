import 'package:mobile_app/classroom/model/classroom.dart';
import 'package:mobile_app/classroom/repository/classroom_repo.dart';
import 'package:mobile_app/supabase/services/classroom_services.dart';
import 'package:mobile_app/user/models/app_user.dart';
import 'package:mobile_app/user/models/student.dart';
import 'package:mobile_app/user/models/teacher.dart';

class ClassroomRepoImpl extends ClassroomRepo {
  ClassroomServices service;

  ClassroomRepoImpl({required this.service});

  @override
  Future<List<Classroom>> fetchClasses(AppUser user) async {
    if (user is Student) {
      final cls = await service.fetchStudentClass(user.classId);

      return [Classroom.fromMap(cls)];
    } else if (user is Teacher) {
      final classrooms = await service.fetchTeacherClasses(user.classIds);
      final List<Classroom> list = [];

      for (var cls in classrooms) {
        list.add(Classroom.fromMap(cls));
      }

      return list;
    } else {
      throw Exception('Inavlid user');
    }
  }
}
