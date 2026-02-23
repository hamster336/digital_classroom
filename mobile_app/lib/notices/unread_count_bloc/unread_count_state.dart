part of 'unread_count_bloc.dart';


sealed class UnreadCountState {}

final class CountLoading extends UnreadCountState {}

final class CountLoaded extends UnreadCountState {
  final int count;
  CountLoaded({required this.count});
}

final class CountError extends UnreadCountState {
  final String message;
  CountError({required this.message});
}
