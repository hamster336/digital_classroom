import 'package:mobile_app/classroom/model/classroom.dart';
import 'package:mobile_app/classroom/repository/classroom_repo.dart';
import 'package:mobile_app/supabase/services/students_services.dart';
import 'package:mobile_app/supabase/services/teachers_services.dart';
import 'package:mobile_app/user/models/app_user.dart';
import 'package:mobile_app/user/models/student.dart';
import 'package:mobile_app/user/models/teacher.dart';

class ClassroomRepoImpl extends ClassroomRepo{
  StudentsServices studentService;
  TeachersServices teacherService;

  ClassroomRepoImpl({required this.studentService, required this.teacherService});

  @override
  Future<List<Classroom>> fetchClasses(AppUser user) async{
    if(user is Student){
      final cls = await studentService.fetchClass(user.classId);

      return [Classroom.fromMap(cls)];

    } else if(user is Teacher){
      final classrooms = await teacherService.fetchClasses(user.classIds);
      final List<Classroom> list = [];

      for(var cls in classrooms){
        list.add(Classroom.fromMap(cls));
      }

      return list;
    }else{
      throw Exception('Inavlid user');
    }
  }

}