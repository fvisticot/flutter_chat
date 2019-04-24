import 'package:equatable/equatable.dart';

abstract class DiscussionsListEvent extends Equatable {
  DiscussionsListEvent([List props = const []]) : super(props);
}

class GetDiscussionsList extends DiscussionsListEvent {
  String userId;

  GetDiscussionsList(this.userId)
      : assert(userId != null),
        super([userId]);

  @override
  String toString() => 'GetDiscussionsList';
}
