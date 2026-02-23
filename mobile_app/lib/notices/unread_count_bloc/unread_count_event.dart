part of 'unread_count_bloc.dart';

sealed class UnreadCountEvent {}

final class LoadUnreadCount extends UnreadCountEvent {
  final DateTime lastChecked;
  LoadUnreadCount({required this.lastChecked});
}

final class ClearCount extends UnreadCountEvent {}
