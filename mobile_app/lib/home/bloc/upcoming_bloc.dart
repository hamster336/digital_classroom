import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.dart';
import 'package:mobile_app/home/model/upcoming.dart';
import 'package:mobile_app/mappers/mapper.dart';
import 'package:mobile_app/notices/repository/notice_repo.dart';

part 'upcoming_event.dart';
part 'upcoming_state.dart';

class UpcomingBloc extends Bloc<UpcomingEvent, UpcomingState> {
  final AssignmentRepo assignRepo;
  final NoticeRepo noticeRepo;

  UpcomingBloc({required this.assignRepo, required this.noticeRepo})
    : super(UpcomingLoading()) {
    on<LoadTeachersEvents>(_loadTeachersEvents);
    on<LoadStudentsEvents>(_loadStudentsEvents);
  }

  // load events for teacher
  Future<void> _loadTeachersEvents(
    LoadTeachersEvents event,
    Emitter<UpcomingState> emit,
  ) async {
    emit(UpcomingLoading());

    final notices = noticeRepo.fetchNotices();
    final assignments = assignRepo.fetchTeachersAssignment(
      teacherId: event.teacherId,
      classId: event.classId,
    );

    final upcoming = [
      ...assignments.map((a) => a.toUpcoming()),
      ...notices
          .where((n) => n.scheduledAt != null)
          .map((n) => n.toUpcomingt()),
    ];

    emit(UpcomingLoaded(events: upcoming));
  }

  // load events for student
  Future<void> _loadStudentsEvents(
    LoadStudentsEvents event,
    Emitter<UpcomingState> emit,
  ) async {
    emit(UpcomingLoading());

    final notices = noticeRepo.fetchNotices();
    final assignments = assignRepo.fetchStudentsAssignment(event.classId);

    final upcoming = [
      ...assignments.map((a) => a.toUpcoming()),
      ...notices
          .where((n) => n.scheduledAt != null)
          .map((n) => n.toUpcomingt()),
    ];

    emit(UpcomingLoaded(events: upcoming));
  }
}
