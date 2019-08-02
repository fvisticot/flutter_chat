import 'package:equatable/equatable.dart';

class TypingUsersState extends Equatable {
  TypingUsersState([List props = const []]) : super(props);
}

class TypingUsersList extends TypingUsersState {
  TypingUsersList(this.usersNames) : super([usersNames]);
  final List<String> usersNames;

  @override
  String toString() => 'TypingUsersList $usersNames';
}

class TypingUsersInitial extends TypingUsersState {
  @override
  String toString() => 'TypingUsersInitial';
}
