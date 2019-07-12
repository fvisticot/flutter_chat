import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/message/message.dart';

abstract class GroupMessagesEvent extends Equatable {
  GroupMessagesEvent([List props = const []]) : super(props);
}

class SyncMessagesEvent extends GroupMessagesEvent {
  SyncMessagesEvent(this.messages)
      : assert(messages != null),
        super([messages]);
  final List<Message> messages;

  @override
  String toString() => 'SyncMessagesEvent';
}

class ErrorSyncMessagesEvent extends GroupMessagesEvent {
  @override
  String toString() => 'ErrorSyncMessagesEvent';
}
