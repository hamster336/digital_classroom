import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.impl.dart';
import 'package:mobile_app/shared/public_directory.dart';
import 'package:mobile_app/submission/repository/submission_repo_impl.dart';

part 'teacher.assignment_event.dart';
part 'teacher.assignment_state.dart';

class TeacherAssignmentBloc
    extends Bloc<TeacherAssignmentEvent, TeacherAssignmentState> {
  final AssignmentRepoImpl assignmentRepo;
  final SubmissionRepoImpl submissionRepo;

  TeacherAssignmentBloc(this.assignmentRepo, this.submissionRepo)
    : super(TeacherAssignmentLoading()) {
    on<LoadTeacherAssignments>(_loadTeacherAssignment);
    on<RefreshAssignments>(_refreshAssignments);
    on<CreateAssignment>(_createAssignment);
    on<UpdateAssignment>(_updateAssignment);
    on<DeleteAssignment>(_deleteAssignment);
    on<DownloadSubmission>(_downloadSubmission);
    on<GradeSubmission>(_gradeSubmission);
  }

  // cache asignments to prevent refetching each time the teacher navigates
  Map<String, List<Assignment>> cachedAssignemnts = {};
  Map<String, List<AppFile>> cachedSubmissions = {};

  // refresh assignments
  Future<void> _refreshAssignments(
    RefreshAssignments event,
    Emitter<TeacherAssignmentState> emit,
  ) async {
    final key = '${event.teacherId}-${event.classId}';

    try {
      final dir = await PublicDirectory.getPublicDirectoryPath();

      final assignments = await assignmentRepo.loadTeachersAssignments(
        event.classId,
        event.teacherId,
      );
      final submissions = await submissionRepo.getSubmissionsForTeacher(
        event.classId,
        assignments.map((a) => a.id!).toList(),
      );

      for (var sub in submissions) {
        final path = '$dir/${sub.fileName}';
        final exists = await File(path).exists();

        sub.isDownloaded = exists;
      }

      cachedAssignemnts[key] = assignments;
      cachedSubmissions[key] = submissions;

      emit(
        TeacherAssignmentLoaded(
          assignments: assignments,
          submissions: submissions,
          downloadProgress: {},
        ),
      );
    } catch (e) {
      emit(TeacherAssignmentLoadingError(message: e.toString()));
    }
  }

  // load assignmentso
  Future<void> _loadTeacherAssignment(
    LoadTeacherAssignments event,
    Emitter<TeacherAssignmentState> emit,
  ) async {
    final key = '${event.teacherId}-${event.classId}';

    if (cachedAssignemnts.containsKey(key)) {
      emit(
        TeacherAssignmentLoaded(
          assignments: cachedAssignemnts[key]!,
          submissions: cachedSubmissions[key]!,
          downloadProgress: {},
        ),
      );
      return;
    }

    emit(TeacherAssignmentLoading());

    try {
      final dir = await PublicDirectory.getPublicDirectoryPath();

      final assignments = await assignmentRepo.loadTeachersAssignments(
        event.classId,
        event.teacherId,
      );
      final submissions = await submissionRepo.getSubmissionsForTeacher(
        event.classId,
        assignments.map((a) => a.id!).toList(),
      );

      for (var sub in submissions) {
        final path = '$dir/${sub.fileName}';
        final exists = await File(path).exists();

        sub.isDownloaded = exists;
      }

      cachedAssignemnts[key] = assignments;
      cachedSubmissions[key] = submissions;

      emit(
        TeacherAssignmentLoaded(
          assignments: assignments,
          submissions: submissions,
          downloadProgress: {},
        ),
      );
    } catch (e) {
      emit(TeacherAssignmentLoadingError(message: e.toString()));
    }
  }

  // particular assignment object lai edit garr ani purai list lai emit grr
  Future<void> _createAssignment(
    CreateAssignment event,
    Emitter<TeacherAssignmentState> emit,
  ) async {
    if (state is! TeacherAssignmentLoaded) return;

    final currentState = (state as TeacherAssignmentLoaded);

    emit(TeacherAssignmentLoading());

    try {
      await assignmentRepo.addAssignment(event.assignment);

      emit(CreateAssignmentSuccess());
    } catch (e) {
      emit(CreateAssignmentError(message: e.toString()));
      emit(currentState);
    }
  }

  // delete assignment
  Future<void> _updateAssignment(
    UpdateAssignment event,
    Emitter<TeacherAssignmentState> emit,
  ) async {
    if (state is! TeacherAssignmentLoaded) return;

    final currentState = (state as TeacherAssignmentLoaded);

    emit(TeacherAssignmentLoading());

    try {
      await assignmentRepo.updateAssignment(event.assignment);
      emit(UpdateAssignmentSuccess());
    } catch (e) {
      emit(UpdateAssignmentError(message: e.toString()));
      emit(currentState);
    }
  }

  // delete assignment
  Future<void> _deleteAssignment(
    DeleteAssignment event,
    Emitter<TeacherAssignmentState> emit,
  ) async {
    if (state is! TeacherAssignmentLoaded) return;

    final currentState = (state as TeacherAssignmentLoaded);

    emit(TeacherAssignmentLoading());

    try {
      await assignmentRepo.deleteAssignment(event.assignmentId);
      emit(DeleteAssignmentSuccess());
      emit(currentState);
    } catch (e) {
      emit(DeleteAssignmentError(message: e.toString()));
      emit(currentState);
    }
  }

  // download submission
  Future<void> _downloadSubmission(
    DownloadSubmission event,
    Emitter<TeacherAssignmentState> emit,
  ) async {
    if (state is! TeacherAssignmentLoaded) return;

    final currentState = state as TeacherAssignmentLoaded;

    final Map<String, double> progressMap = currentState.downloadProgress;

    try {
      progressMap[event.submission.id!] = 0;
      emit(currentState.copyWith(downloadProgress: progressMap));

      await submissionRepo.downloadSubmission(
        fileName: event.submission.fileName,
        filePath: event.submission.filePath,
        className: event.className,
        onProgress: (received, total) {
          final progress = received / total;

          progressMap[event.submission.id!] = progress;
          emit(currentState.copyWith(downloadProgress: progressMap));
        },
      );

      progressMap.remove(event.submission.id);

      emit(DownloadAssignmentSubmissionSuccess());
      emit(currentState.copyWith(downloadProgress: progressMap));
    } catch (e) {
      progressMap.remove(event.submission.id!);
      emit(DownloadAssignmentSubmissionError(message: e.toString()));
      emit(currentState);
    }
  }

  // grade submission
  Future<void> _gradeSubmission(
    GradeSubmission event,
    Emitter<TeacherAssignmentState> emit,
  ) async {
    if (state is! TeacherAssignmentLoaded) return;

    final currentState = state as TeacherAssignmentLoaded;

    try {
      emit(TeacherAssignmentLoading());

      await submissionRepo.gradeSubmission(
        submissionId: event.submissionId,
        score: event.score,
        remarks: event.remarks,
      );

      emit(GradeSubmissionSuccess());
    } catch (e) {
      emit(GradeSubmissionError(message: e.toString()));
    }
    emit(currentState);
  }
}
