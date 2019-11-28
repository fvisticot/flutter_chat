import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/discussion.dart';

abstract class DiscussionsListEvent extends Equatable {
  const DiscussionsListEvent();
}

class GetDiscussionsList extends DiscussionsListEvent {
  @override
  String toString() => 'GetDiscussionsList';
  @override
  List<Object> get props => [];
}

class SyncDiscussionsList extends DiscussionsListEvent {
  const SyncDiscussionsList(this.discussions);
  final List<Discussion> discussions;

  @override
  String toString() => 'SyncDiscussionsList';
  @override
  List<Object> get props => [discussions];
}

class ErrorSyncDiscussionsList extends DiscussionsListEvent {
  @override
  String toString() => 'ErrorSyncDiscussionsList';
  @override
  List<Object> get props => [];
}
