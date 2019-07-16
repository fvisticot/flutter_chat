import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/discussion.dart';

abstract class DiscussionsListEvent extends Equatable {
  DiscussionsListEvent([List props = const []]) : super(props);
}

class GetDiscussionsList extends DiscussionsListEvent {
  @override
  String toString() => 'GetDiscussionsList';
}

class SyncDiscussionsList extends DiscussionsListEvent {
  SyncDiscussionsList(this.discussions) : super([discussions]);
  List<Discussion> discussions;

  @override
  String toString() => 'SyncDiscussionsList';
}
