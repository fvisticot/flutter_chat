import 'package:equatable/equatable.dart';

class TypingUsersEvent extends Equatable {
  final List<String> usersNames;

  TypingUsersEvent(this.usersNames)
  :assert (usersNames!=null),
  super([usersNames]);

  @override
  String toString() => 'TypingUsersEvent $usersNames';
}