import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  ChatEvent([List props = const []]) : super(props);
}

class ChatStarted extends ChatEvent {
  ChatStarted(this.userName)
      : assert(userName != null),
        super([userName]);
  String userName;

  @override
  String toString() => 'ChatStarted';
}
