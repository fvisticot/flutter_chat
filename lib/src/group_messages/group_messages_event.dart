import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/message/message.dart';

abstract class GroupMessagesEvent extends Equatable {
  const GroupMessagesEvent();
}

class SyncMessagesEvent extends GroupMessagesEvent {
  const SyncMessagesEvent(this.messages) : assert(messages != null);
  final List<Message> messages;

  @override
  String toString() => 'SyncMessagesEvent{messages: $messages}';
  @override
  List<Object> get props => [messages];
}

class ErrorSyncMessagesEvent extends GroupMessagesEvent {
  @override
  String toString() => 'ErrorSyncMessagesEvent';
  @override
  List<Object> get props => [];
}
