import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  ChatEvent([List props = const []]) : super(props);
}

class ChatStarted extends ChatEvent {
  String userName;

  ChatStarted(this.userName)
  : assert(userName != null),
  super([userName]);

  @override
  String toString() => 'ChatStarted';
}
