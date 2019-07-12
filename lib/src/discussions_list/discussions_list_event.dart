import 'package:equatable/equatable.dart';

abstract class DiscussionsListEvent extends Equatable {
  DiscussionsListEvent([List props = const []]) : super(props);
}

class GetDiscussionsList extends DiscussionsListEvent {
  @override
  String toString() => 'GetDiscussionsList';
}

class SyncDiscussionsList extends DiscussionsListEvent {
  SyncDiscussionsList(this.discussions) : super([discussions]);
  Map<String, dynamic> discussions;

  @override
  String toString() => 'SyncDiscussionsList';
}
