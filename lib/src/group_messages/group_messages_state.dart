import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/message/message.dart';

abstract class GroupMessagesState extends Equatable {
  GroupMessagesState([List props = const []]) : super(props);
}

class GroupMessagesInitial extends GroupMessagesState {
  @override
  String toString() => 'GroupMessagesInitial';
}

class GroupMessagesLoading extends GroupMessagesState {
  @override
  String toString() => 'GroupMessagesLoading';
}

class GroupMessagesError extends GroupMessagesState {
  String error;

  GroupMessagesError({this.error}) : super([error]);

  @override
  String toString() => 'GroupMessagesError $error';
}

class GroupMessagesSuccess extends GroupMessagesState {
  final List<Message> messages;

  GroupMessagesSuccess(this.messages) : super([messages]);

  @override
  String toString() => 'GroupMessagesSuccess';
}
