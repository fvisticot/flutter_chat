import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/message/message.dart';
import 'package:meta/meta.dart';

abstract class MessageBarEvent extends Equatable {
  const MessageBarEvent();
}

class IsTyping extends MessageBarEvent {
  const IsTyping({@required this.isTyping}) : assert(isTyping != null);
  final bool isTyping;

  @override
  String toString() => 'IsTyping{isTyping: $isTyping}';
  @override
  List<Object> get props => [isTyping];
}

class SendMessageEvent extends MessageBarEvent {
  const SendMessageEvent(this.message) : assert(message != null);
  final Message message;

  @override
  String toString() => 'SendMessageEvent{message: $message';
  @override
  List<Object> get props => [message];
}

class StoreImageEvent extends MessageBarEvent {
  const StoreImageEvent(this.imageFile) : assert(imageFile != null);
  final File imageFile;

  @override
  String toString() => 'StoreImageEvent{imageFile: $imageFile}';
  @override
  List<Object> get props => [imageFile];
}
