import 'package:mobile_app/subject/model/subject.dart';
import 'package:mobile_app/subject/repository/subject_repo.dart';
import 'package:mobile_app/supabase/services/subject_services.dart';

class SubjectRepoImpl extends SubjectRepo {
  final SubjectServices service;

  SubjectRepoImpl({required this.service});

  @override
  Future<List<Subject>> fetchSubjects(List<String> subjectIds) async{
    final subjects = await service.fetchSubjects(subjectIds);
    List<Subject> list = [];

    for(var sub in subjects){
      list.add(Subject.fromMap(sub));
    }

    return list;
  }
}
