import 'package:equatable/equatable.dart';

class TypingUsersEvent extends Equatable {
  TypingUsersEvent(this.usersNames)
      : assert(usersNames != null),
        super([usersNames]);
  final List<String> usersNames;

  @override
  String toString() => 'TypingUsersEvent $usersNames';
}
