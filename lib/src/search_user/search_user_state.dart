import 'package:equatable/equatable.dart';

abstract class SearchUserState extends Equatable {
  SearchUserState([List props = const []]) : super(props);
}

class SearchUserInitial extends SearchUserState {
  @override
  String toString() => 'SearchUserInitial';
}

class SearchUserList extends SearchUserState {
  SearchUserList(this.users) : super([users]);
  final Map<String, String> users;

  @override
  String toString() => 'SearchUserList $users';
}

class SearchUserGroupChat extends SearchUserState {
  SearchUserGroupChat(this.groupId) : super([groupId]);
  final String groupId;

  @override
  String toString() => 'SearchUserGroupChat $groupId';
}

class SearchUserCreatingGroup extends SearchUserState {
  @override
  String toString() => 'CreatingGroup';
}
