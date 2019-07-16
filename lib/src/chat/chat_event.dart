import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  ChatEvent([List props = const []]) : super(props);
}

class ChatStarted extends ChatEvent {
  @override
  String toString() => 'ChatStarted';
}
