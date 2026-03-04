import 'package:bloc/bloc.dart';
import 'package:mobile_app/assignments/repository/assignment_repo.impl.dart';

part 'teachers_dashboard_event.dart';
part 'teachers_dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AssignmentRepoImpl repository;

  DashboardBloc(this.repository) : super(DashboardLoading()) {
    on<LoadActiveAssignmentCount>((event, emit) async {
      try {
        final activeCount = await repository.fetchActiveAssignmentCount(
          event.teacherId,
        );

        emit(DashboardLoaded(activeAssignmentCount: activeCount));
      } catch (e) {
        emit(DashboardLoadingError(message: e.toString()));
      }
    });
  }
}
