import 'package:equatable/equatable.dart';

class TypingUsersState extends Equatable {
  TypingUsersState([List props = const []]) : super(props);
}

class TypingUsersList extends TypingUsersState {
  List<String> usersNames;

  TypingUsersList(this.usersNames)
      : super([usersNames]);

  @override
  String toString() => 'TypingUsersList $usersNames';
}

class TypingUsersInitial extends TypingUsersState {
  @override
  String toString() => 'TypingUsersInitial';
}

