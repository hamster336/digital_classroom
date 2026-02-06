import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/upcoming/model/upcoming.dart';
import 'package:mobile_app/upcoming/repository/upcoming_repo_impl.dart';
import 'package:mobile_app/user/models/student.dart';

part 'upcoming_event.dart';
part 'upcoming_state.dart';

class UpcomingBloc extends Bloc<UpcomingEvent, UpcomingState> {
  final UpcomingRepoImpl repo;

  UpcomingBloc({required this.repo}) : super(UpcomingLoading()) {
    on<LoadEvents>(_loadEvents);
  }

  // load events for teacher and student
  Future<void> _loadEvents(
    LoadEvents event,
    Emitter<UpcomingState> emit,
  ) async {
    emit(UpcomingLoading());

    try {
      final upcoming = await repo.fetchUpcomingEvents(event.subjectIds);
      emit(UpcomingLoaded(events: upcoming));
    } catch (e) {
      emit(UpcomingError(message: e.toString()));
    }
  }
}
