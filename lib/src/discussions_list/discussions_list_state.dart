import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/discussion.dart';

abstract class DiscussionsListState extends Equatable {
  const DiscussionsListState();
}

class DiscussionsInitial extends DiscussionsListState {
  @override
  String toString() => 'DiscussionsInitial';
  @override
  List<Object> get props => [];
}

class DiscussionsLoading extends DiscussionsListState {
  @override
  String toString() => 'DiscussionsLoading';
  @override
  List<Object> get props => [];
}

class DiscussionsSuccess extends DiscussionsListState {
  const DiscussionsSuccess(this.discussions) : assert(discussions != null);
  final List<Discussion> discussions;

  @override
  String toString() => 'DiscussionsSuccess $discussions';
  @override
  List<Object> get props => [discussions];
}

class DiscussionsError extends DiscussionsListState {
  const DiscussionsError(this.error);
  final String error;

  @override
  String toString() => 'DiscussionsError : $error';
  @override
  List<Object> get props => [error];
}
