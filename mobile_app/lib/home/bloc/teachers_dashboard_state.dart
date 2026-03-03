part of 'teachers_dashboard_bloc.dart';

sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardLoaded extends DashboardState {
  final int activeAssignmentCount;
  DashboardLoaded({required this.activeAssignmentCount});
}

final class DashboardLoadingError extends DashboardState {
  final String message;
  DashboardLoadingError({required this.message});
}
