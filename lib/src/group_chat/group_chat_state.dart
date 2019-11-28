import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/group.dart';

abstract class GroupChatState extends Equatable {
  const GroupChatState();
}

class GroupChatInitial extends GroupChatState {
  @override
  String toString() => 'GroupChatInitial';
  @override
  List<Object> get props => [];
}

class GroupChatLoading extends GroupChatState {
  @override
  String toString() => 'GroupChatLoading';
  @override
  List<Object> get props => [];
}

class GroupChatSuccess extends GroupChatState {
  const GroupChatSuccess(this.group) : assert(group != null);
  final Group group;

  @override
  String toString() => 'GroupChatSuccess{group: $group}';
  @override
  List<Object> get props => [group];
}

class GroupChatError extends GroupChatState {
  @override
  String toString() => 'GroupChatError';
  @override
  List<Object> get props => [];
}
