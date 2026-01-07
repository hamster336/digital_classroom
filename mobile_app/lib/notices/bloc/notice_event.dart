part of 'notice_bloc.dart';

sealed class NoticeEvent {}

final class LoadNotices extends NoticeEvent {}

final class FilterNotices extends NoticeEvent {
  final NoticeFilter filter ;
  FilterNotices({required this.filter});
}
