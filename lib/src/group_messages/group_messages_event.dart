import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/message.dart';

abstract class GroupMessagesEvent extends Equatable {
  GroupMessagesEvent([List props = const []]) : super(props);
}

class SyncMessagesEvent extends GroupMessagesEvent {
  final List<Message> messages;

  SyncMessagesEvent(this.messages)
      : assert(messages!= null),
        super([messages]);

  @override
  String toString() => 'SyncMessagesEvent';
}
