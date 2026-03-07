part of 'notes_bloc.dart';

sealed class NotesEvent {}

final class LoadNotesForTeacher extends NotesEvent {
  final String teacherId;
  final String classId;

  LoadNotesForTeacher({required this.teacherId, required this.classId});
}

final class RefreshNotesForTeacher extends NotesEvent {
  final String teacherId;
  final String classId;

  RefreshNotesForTeacher({required this.teacherId, required this.classId});
}

final class LoadNotesForStudent extends NotesEvent {
  final String classId;
  final List<String> subjectId;

  LoadNotesForStudent({
    required this.classId,
    required this.subjectId,
  });
}

final class RefreshNotesForStudent extends NotesEvent {
  final String classId;
  final List<String> subjectIds;

  RefreshNotesForStudent({
    required this.classId,
    required this.subjectIds,
  });
}

final class UploadNotes extends NotesEvent {
  final List<PlatformFile> notes;
  final String teacherId;
  final String classId;
  final String subjectId;

  UploadNotes({
    required this.notes,
    required this.teacherId,
    required this.classId,
    required this.subjectId,
  });
}

final class DownloadNote extends NotesEvent {
  final AppFile note;

  DownloadNote({required this.note});
}

final class DeleteNote extends NotesEvent {
  final String noteId;
  final String filePath;

  DeleteNote({required this.noteId, required this.filePath});
}
