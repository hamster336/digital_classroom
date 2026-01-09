import 'package:bloc/bloc.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.dart';
import 'package:mobile_app/home/model/upcoming.dart';
import 'package:mobile_app/mappers/mapper.dart';
import 'package:mobile_app/notices/repository/notice_repo.dart';

part 'upcoming_event.dart';
part 'upcoming_state.dart';

class UpcomingBloc extends Bloc<UpcomingEvent, UpcomingState> {
  UpcomingBloc() : super(UpcomingLoading()) {
    on<LoadUpcomingEvents>((event, emit) {
      emit(UpcomingLoading());

      final notices = NoticeRepo().getNotice;
      final assignments = AssignmentRepo().getAssignments;

      final upcoming = [
        ...assignments.map((a) => a.toUpcoming()),
        ...notices
            .where((n) => n.scheduledAt != null)
            .map((n) => n.toUpcomingt()),
      ];

      emit(UpcomingLoaded(events: upcoming));
    });
  }
}
