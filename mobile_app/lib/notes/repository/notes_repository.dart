import 'package:file_picker/file_picker.dart';
import 'package:mobile_app/app_file/models/app_file.dart';

abstract class NotesRepository {
  Future<List<AppFile>> loadNotesForStudent({
    required String classId,
    required List<String> subjectIds,
    required int from,
    required int limit,
  });

  Future<List<AppFile>> loadNotesForTeacher({
    required String classId,
    required String teacherId,
    required int from,
    required int limit,
  });

  Future<void> uploadNotes({
    required List<PlatformFile> files,
    required String teacherId,
    required String classId,
    required String subjectId,
  });

  Future<void> deleteNote(String noteId, String filePath);

  Future<void> downloadNote({
    required String filePath,
    required String fileName,
    required Function(int recieved, int total) onProgress,
  });
}
