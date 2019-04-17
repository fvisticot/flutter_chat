import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/message/message.dart';

abstract class MessageBarEvent extends Equatable {
  MessageBarEvent([List props = const []]) : super(props);
}

class IsTyping extends MessageBarEvent {
  final bool isTyping;

  IsTyping(this.isTyping)
      : assert(isTyping != null),
        super([isTyping]);

  @override
  String toString() => 'IsTyping $isTyping';
}

class SendMessageEvent extends MessageBarEvent {
  final Message message;

  SendMessageEvent(this.message)
      : assert(message != null),
        super([message]);
  @override
  String toString() => 'SendMessageEvent';
}

class StoreImageEvent extends MessageBarEvent {
  final File imageFile;

  StoreImageEvent(this.imageFile)
      : assert(imageFile != null),
        super([imageFile]);
  @override
  String toString() => 'StoreImageEvent $imageFile';
}
