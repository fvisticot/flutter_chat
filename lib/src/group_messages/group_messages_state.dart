import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/message/message.dart';

abstract class GroupMessagesState extends Equatable {
  GroupMessagesState([List props = const []]) : super(props);
}

class GroupMessagesInitial extends GroupMessagesState {
  @override
  String toString() => 'GroupMessagesInitial';
}

class GroupMessagesError extends GroupMessagesState {
  GroupMessagesError({this.error}) : super([error]);
  final String error;

  @override
  String toString() => 'GroupMessagesError $error';
}

class GroupMessagesSuccess extends GroupMessagesState {
  GroupMessagesSuccess(this.messages) : super([messages]);
  final List<Message> messages;

  @override
  String toString() => 'GroupMessagesSuccess';
}
