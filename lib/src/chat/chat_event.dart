import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class ChatStarted extends ChatEvent {
  @override
  String toString() => 'ChatStarted';
  @override
  List<Object> get props => [];
}
