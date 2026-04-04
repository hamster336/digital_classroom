import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/notes/repository/notes_repository_impl.dart';
import 'package:mobile_app/shared/public_directory.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepositoryImpl repository;
  NotesBloc(this.repository) : super(NotesInitial()) {
    on<LoadNotesForTeacher>(_loadNotesForTeacher);
    on<RefreshNotesForTeacher>(_refreshNotesForTeacher);
    on<LoadNotesForStudent>(_loadNotesForStudent);
    on<RefreshNotesForStudent>(_refreshNotesForStudent);
    on<UploadNotes>(_uploadNote);
    on<DownloadNote>(_downloadNote);
    on<DeleteNote>(_deleteNote);
  }

  static const int pageSize = 10;

  /// FOR TEACHER

  // to temporarily cache loaded data for teacher
  Map<String, List<AppFile>> cachedNotesForTeacher = {};
  Map<String, bool> cachedReachedMaxForTeacher = {};

  // refresh on scroll down
  Future<void> _refreshNotesForTeacher(
    RefreshNotesForTeacher event,
    Emitter<NotesState> emit,
  ) async {
    final key = '${event.teacherId}-${event.classId}';

    try {
      int from = 0;
      final notes = await repository.loadNotesForTeacher(
        classId: event.classId,
        teacherId: event.teacherId,
        from: from,
        limit: pageSize,
      );

      cachedNotesForTeacher[key] = notes;
      cachedReachedMaxForTeacher[key] = notes.length < pageSize;

      emit(
        NotesLoaded(
          notes: notes,
          hasReachedMax: notes.length < pageSize,
          isLoadingMore: false,
          downloadProgress: {},
        ),
      );
    } catch (e) {
      emit(NotesLoadingError(message: e.toString()));
    }
  }

  // load notes with pagination
  Future<void> _loadNotesForTeacher(
    LoadNotesForTeacher event,
    Emitter<NotesState> emit,
  ) async {
    if (state is NotesLoaded && (state as NotesLoaded).hasReachedMax) return;

    final key = '${event.teacherId}-${event.classId}';

    if (cachedNotesForTeacher.containsKey(key) &&
        cachedReachedMaxForTeacher.containsKey(key)) {
      emit(
        NotesLoaded(
          notes: cachedNotesForTeacher[key]!,
          hasReachedMax: cachedReachedMaxForTeacher[key]!,
          isLoadingMore: false,
          downloadProgress: {},
        ),
      );
    }

    try {
      final currentState = state;

      List<AppFile> oldNotes = [];
      int from = 0;

      if (currentState is NotesLoaded) {
        oldNotes = currentState.notes;
        from = oldNotes.length;
      }

      if (oldNotes.isEmpty) {
        emit(NotesLoading());
      } else {
        emit(
          NotesLoaded(
            notes: oldNotes,
            hasReachedMax: false,
            isLoadingMore: true,
            downloadProgress: {},
          ),
        );
      }

      final newNotes = await repository.loadNotesForTeacher(
        classId: event.classId,
        teacherId: event.teacherId,
        from: from,
        limit: pageSize,
      );

      cachedNotesForTeacher[key] = oldNotes + newNotes;
      cachedReachedMaxForTeacher[key] = newNotes.length < pageSize;

      emit(
        NotesLoaded(
          notes: oldNotes + newNotes,
          hasReachedMax: newNotes.length < pageSize,
          isLoadingMore: false,
          downloadProgress: {},
        ),
      );
    } catch (e) {
      emit(NotesLoadingError(message: e.toString()));
    }
  }

  // upload notes
  Future<void> _uploadNote(UploadNotes event, Emitter<NotesState> emit) async {
    if (state is! NotesLoaded) return;

    emit(NotesLoading());

    try {
      await repository.uploadNotes(
        files: event.notes,
        teacherId: event.teacherId,
        classId: event.classId,
        subjectId: event.subjectId,
      );
      emit(UploadNoteSuccess());
    } catch (e) {
      emit(UploadNoteError(message: e.toString()));
    }
  }

  // delete note
  Future<void> _deleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    if (state is! NotesLoaded) return;

    final currentState = state;

    emit(NotesLoading());

    try {
      await repository.deleteNote(event.noteId, event.filePath);
      emit(DeleteNoteSuccess());
      emit(currentState);
    } catch (e) {
      emit(DeleteNoteError(message: e.toString()));
    }
  }

  /// FOR STUDENTS

  List<AppFile> cachedNotesForStudent = [];
  bool cachedReachedMaxForStudent = false;

  // download notes
  Future<void> _downloadNote(
    DownloadNote event,
    Emitter<NotesState> emit,
  ) async {
    if (state is! NotesLoaded) return;

    try {
      final currentState = state as NotesLoaded;
      final Map<String, double> progressMap = Map<String, double>.from(
        currentState.downloadProgress,
      );

      // start the download
      progressMap[event.note.id!] = 0;
      double lastProgress = 0;

      emit(currentState.copyWith(downloadProgress: progressMap));

      await repository.downloadNote(
        filePath: event.note.filePath,
        fileName: event.note.fileName,
        onProgress: (received, total) {
          if (state is! NotesLoaded) return;

          final progress = received / total;

          if ((progress - lastProgress) > 0.05) {
            lastProgress = progress;

            final latestState = state as NotesLoaded;
            final updatedMap = Map<String, double>.from(
              latestState.downloadProgress,
            );

            updatedMap[event.note.id!] = received / total;

            emit(latestState.copyWith(downloadProgress: updatedMap));
          }
        },
      );

      if (state is! NotesLoaded) return;

      final latestState = state as NotesLoaded;
      final updatedMap = Map<String, double>.from(latestState.downloadProgress);

      updatedMap.remove(event.note.id);

      event.note.isDownloaded = true;

      emit(latestState.copyWith(downloadProgress: updatedMap));
    } catch (e) {
      if (state is! NotesLoaded) return;

      final latestState = state as NotesLoaded;
      final updatedMap = Map<String, double>.from(latestState.downloadProgress);

      updatedMap.remove(event.note.id);

      emit(DownloadNoteError(message: e.toString()));
      emit(latestState.copyWith(downloadProgress: updatedMap));
    }
  }

  // refresh on scroll down
  Future<void> _refreshNotesForStudent(
    RefreshNotesForStudent event,
    Emitter<NotesState> emit,
  ) async {
    if (state is! NotesLoaded) return;

    try {
      final dir = await PublicDirectory.getPublicDirectoryPath();

      int from = 0;
      final notes = await repository.loadNotesForStudent(
        classId: event.classId,
        subjectIds: event.subjectIds,
        from: from,
        limit: pageSize,
      );

      for (var note in notes) {
        final path = '$dir/${note.fileName}';
        final exists = await File(path).exists();

        note.isDownloaded = exists;
      }

      cachedNotesForStudent = notes;
      cachedReachedMaxForStudent = notes.length < pageSize;

      emit(
        NotesLoaded(
          notes: notes,
          hasReachedMax: notes.length < pageSize,
          isLoadingMore: false,
          downloadProgress: {},
        ),
      );
    } catch (e) {
      emit(NotesLoadingError(message: e.toString()));
    }
  }

  // load notes with pagination
  Future<void> _loadNotesForStudent(
    LoadNotesForStudent event,
    Emitter<NotesState> emit,
  ) async {
    if (state is NotesLoaded && (state as NotesLoaded).hasReachedMax) return;

    if (cachedNotesForStudent.isEmpty) {
      emit(
        NotesLoaded(
          notes: cachedNotesForStudent,
          hasReachedMax: cachedReachedMaxForStudent,
          isLoadingMore: false,
          downloadProgress: {},
        ),
      );
    }

    try {
      final currentState = state;
      final dir = await PublicDirectory.getPublicDirectoryPath();

      List<AppFile> oldNotes = [];
      int from = 0;
      Map<String, double> progress = {};

      if (currentState is NotesLoaded) {
        oldNotes = currentState.notes;
        from = oldNotes.length;
        progress = currentState.downloadProgress;
      }

      if (oldNotes.isEmpty) {
        emit(NotesLoading());
      } else {
        emit(
          NotesLoaded(
            notes: oldNotes,
            hasReachedMax: false,
            isLoadingMore: true,
            downloadProgress: progress,
          ),
        );
      }

      final newNotes = await repository.loadNotesForStudent(
        classId: event.classId,
        subjectIds: event.subjectId,
        from: from,
        limit: pageSize,
      );

      for (var note in newNotes) {
        final path = '$dir/${note.fileName}';
        final exists = await File(path).exists();

        note.isDownloaded = exists;
      }

      cachedNotesForStudent = oldNotes + newNotes;
      cachedReachedMaxForStudent = newNotes.length < pageSize;

      emit(
        NotesLoaded(
          notes: oldNotes + newNotes,
          hasReachedMax: newNotes.length < pageSize,
          isLoadingMore: false,
          downloadProgress: {},
        ),
      );
    } catch (e) {
      emit(NotesLoadingError(message: e.toString()));
    }
  }
}
