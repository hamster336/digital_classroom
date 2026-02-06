import 'package:mobile_app/subject/model/subject.dart';

abstract class SubjectRepo {
  Future<List<Subject>> fetchSubjects(List<String> subjectIds);

}
