import 'package:equatable/equatable.dart';

abstract class DiscussionsListState extends Equatable {
  DiscussionsListState([List props = const []]) : super(props);
}

class DiscussionsInitial extends DiscussionsListState {
  @override
  String toString() => 'DiscussionsInitial';
}

class DiscussionsLoading extends DiscussionsListState {
  @override
  String toString() => 'DiscussionsLoading';
}

class DiscussionsSuccess extends DiscussionsListState {
  Map<String, String> discussions;

  DiscussionsSuccess(this.discussions)
      : assert(discussions != null),
        super([discussions]);

  @override
  String toString() => 'DiscussionsSuccess $discussions';
}

class DiscussionsError extends DiscussionsListState {
  @override
  String toString() => 'DiscussionsError';
}
