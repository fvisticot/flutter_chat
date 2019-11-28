import 'package:equatable/equatable.dart';

abstract class TypingUsersState extends Equatable {
  const TypingUsersState();
}

class TypingUsersList extends TypingUsersState {
  const TypingUsersList(this.usersNames);
  final List<String> usersNames;

  @override
  String toString() => 'TypingUsersList{userNames: $usersNames}';
  @override
  List<Object> get props => [usersNames];
}

class TypingUsersInitial extends TypingUsersState {
  @override
  String toString() => 'TypingUsersInitial';
  @override
  List<Object> get props => [];
}
