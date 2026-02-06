part of 'upcoming_bloc.dart';

sealed class UpcomingState {}

final class UpcomingLoading extends UpcomingState {}

final class UpcomingLoaded extends UpcomingState {
  List<Upcoming> events;

  UpcomingLoaded({required this.events});

  List<Upcoming> get displayEvents {
    final now = DateTime.now();

    // final upcoming = events.where((e) => !e.eventAt.isBefore(now)).toList();
    final upcoming = events.where((e) => now.isBefore(e.eventAt)).toList();

    upcoming.sort((a, b) => a.eventAt.compareTo(b.eventAt));

    return upcoming.take(3).toList();
  }
}

final class UpcomingError extends UpcomingState {
  final String message;
  UpcomingError({required this.message});
}
