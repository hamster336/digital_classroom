import 'package:mobile_app/classroom/model/classroom.dart';
import 'package:mobile_app/user/models/app_user.dart';

abstract class ClassroomRepo {
  Future<List<Classroom>> fetchClasses(AppUser user);
}
