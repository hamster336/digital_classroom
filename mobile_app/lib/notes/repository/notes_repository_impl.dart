import 'package:file_picker/file_picker.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/notes/repository/notes_repository.dart';
import 'package:mobile_app/shared/public_directory.dart';
import 'package:mobile_app/supabase/services/notes_services.dart';

class NotesRepositoryImpl extends NotesRepository {
  final NotesServices services;

  NotesRepositoryImpl({required this.services});

  @override
  Future<List<AppFile>> loadNotesForStudent({
    required String classId,
    required List<String> subjectIds,
    required int from,
    required int limit,
  }) async {
    try {
      final notes = await services.fetchStudentNotes(
        classId: classId,
        subjectIds: subjectIds,
        from: from,
        limit: limit,
      );

      return notes.map((n) => AppFile.fromMap(n)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<AppFile>> loadNotesForTeacher({
    required String classId,
    required String teacherId,
    required int from,
    required int limit,
  }) async {
    try {
      final notes = await services.fetchTeacherNotes(
        classId: classId,
        teacherId: teacherId,
        from: from,
        limit: limit,
      );

      return notes.map((n) => AppFile.fromMap(n)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> uploadNotes({
    required List<PlatformFile> files,
    required String teacherId,
    required String classId,
    required String subjectId,
  }) async {
    try {
      await services.addNotes(
        files: files,
        teacherId: teacherId,
        classId: classId,
        subjectId: subjectId,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteNote(String noteId, String filePath) async {
    try {
      await services.deleteNote(noteId, filePath);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> downloadNote({
    required String filePath,
    required String fileName,
    required Function(int recieved, int total) onProgress,
  }) async {
    try {
      final directory = await PublicDirectory.getPublicDirectoryPath();
      await services.downloadNote(
        filePath: filePath,
        fileName: fileName,
        directory: directory!,
        onProgress: (recieved, total) => onProgress(recieved, total),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
