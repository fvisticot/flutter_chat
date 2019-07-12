import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/message/message.dart';
import 'package:meta/meta.dart';

abstract class MessageBarEvent extends Equatable {
  MessageBarEvent([List props = const []]) : super(props);
}

class IsTyping extends MessageBarEvent {
  IsTyping({@required this.isTyping})
      : assert(isTyping != null),
        super([isTyping]);
  final bool isTyping;

  @override
  String toString() => 'IsTyping $isTyping';
}

class SendMessageEvent extends MessageBarEvent {
  SendMessageEvent(this.message)
      : assert(message != null),
        super([message]);
  final Message message;

  @override
  String toString() => 'SendMessageEvent';
}

class StoreImageEvent extends MessageBarEvent {
  StoreImageEvent(this.imageFile)
      : assert(imageFile != null),
        super([imageFile]);
  final File imageFile;

  @override
  String toString() => 'StoreImageEvent $imageFile';
}
