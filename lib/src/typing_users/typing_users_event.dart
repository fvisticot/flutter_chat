import 'package:equatable/equatable.dart';

class TypingUsersEvent extends Equatable {
  const TypingUsersEvent(this.usersNames) : assert(usersNames != null);
  final List<String> usersNames;

  @override
  String toString() => 'TypingUsersEvent{userNames: $usersNames}';
  @override
  List<Object> get props => [usersNames];
}
