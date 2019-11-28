import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/message/message.dart';

abstract class GroupMessagesState extends Equatable {
  const GroupMessagesState();
}

class GroupMessagesInitial extends GroupMessagesState {
  @override
  String toString() => 'GroupMessagesInitial';
  @override
  List<Object> get props => [];
}

class GroupMessagesError extends GroupMessagesState {
  const GroupMessagesError({this.error});
  final String error;

  @override
  String toString() => 'GroupMessagesError{error: $error}';
  @override
  List<Object> get props => [error];
}

class GroupMessagesSuccess extends GroupMessagesState {
  const GroupMessagesSuccess(this.messages);
  final List<Message> messages;

  @override
  String toString() => 'GroupMessagesSuccess{messages: $messages}';
  @override
  List<Object> get props => [messages];
}
