import 'package:equatable/equatable.dart';

abstract class DiscussionsListEvent extends Equatable {
  DiscussionsListEvent([List props = const []]) : super(props);
}

class GetDiscussionsList extends DiscussionsListEvent {
  @override
  String toString() => 'GetDiscussionsList';
}

class SyncDiscussionsList extends DiscussionsListEvent {
  Map<String, dynamic> discussions;

  SyncDiscussionsList(this.discussions) : super([discussions]);

  @override
  String toString() => 'SyncDiscussionsList';
}
