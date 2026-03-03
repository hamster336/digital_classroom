import 'package:mobile_app/assignments/models/assignment.dart';

abstract class AssignmentRepo {
  Future<List<Assignment>> loadTeachersAssignments(String classId, String teacherId);

  Future<int> fetchActiveAssignmentCount(String teacherId);

  Future<List<Assignment>> loadStudentsAssignments(String classId, List<String> subjectIds);

  Future<void> addAssignment(Assignment assignment);

  Future<void> updateAssignment(Assignment assignment);

  Future<void> deleteAssignment(String id);
}
