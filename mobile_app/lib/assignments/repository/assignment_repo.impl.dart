import 'dart:developer';

import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.dart';
import 'package:mobile_app/supabase/services/assignment_services.dart';

class AssignmentRepoImpl extends AssignmentRepo {
  final AssignmentServices services;

  AssignmentRepoImpl({required this.services});

  @override
  // load assignments for teacher
  Future<List<Assignment>> loadTeachersAssignments(
    String classId,
    String teacherId,
  ) async {
    try {
      final assignments = await services.fetchTeachersAssignments(
        teacherId,
        classId,
      );

      return assignments.map((a) => Assignment.fromMap(a)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<int> fetchActiveAssignmentCount(String teacherId) async {
    try {
      final count = await services.fetchActiveAssignmentCount(teacherId);

      return count;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // load assignments for student
  @override
  Future<List<Assignment>> loadStudentsAssignments(
    String classId,
    List<String> subjectIds,
  ) async {
    try {
      final assignments = await services.fetchStudentsAssignments(
        classId,
        subjectIds,
      );

      return assignments.map((a) => Assignment.fromMap(a)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  // add assignment
  Future<void> addAssignment(Assignment assignment) async {
    try {
      await services.addAssignment(Assignment.toMap(assignment));
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateAssignment(Assignment assignment) async {
    try {
      await services.updateAssignment(Assignment.toMap(assignment));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteAssignment(String id) async {
    try {
      await services.deleteAssignment(id);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
