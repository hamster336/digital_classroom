part of 'teachers_dashboard_bloc.dart';

sealed class DashboardEvent {}

final class LoadActiveAssignmentCount extends DashboardEvent {
  final String teacherId;
  LoadActiveAssignmentCount({required this.teacherId});
}
