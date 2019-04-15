import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/group.dart';

abstract class GroupChatState extends Equatable {
  GroupChatState([List props = const []]) : super(props);
}

class GroupChatInitial extends GroupChatState {
  @override
  String toString() => 'GroupChatInitial';
}

class GroupChatLoading extends GroupChatState {
  @override
  String toString() => 'GroupChatLoading';
}

class GroupChatSuccess extends GroupChatState {
  Group group;

  GroupChatSuccess(this.group)
  : assert(group != null),
  super([group]);

  @override
  String toString() => 'GroupChatSuccess $group';
}

class GroupChatError extends GroupChatState {
  @override
  String toString() => 'GroupChatError';
}