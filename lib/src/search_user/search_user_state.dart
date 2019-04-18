import 'package:equatable/equatable.dart';

abstract class SearchUserState extends Equatable {
  SearchUserState([List props = const []]) : super(props);
}

class SearchUserInitial extends SearchUserState {
  @override
  String toString() => 'SearchUserInitial';
}

class SearchUserList extends SearchUserState {
  Map<String, String> users;
  SearchUserList(this.users) : super([users]);

  @override
  String toString() => 'SearchUserList $users';
}

class SearchUserGroupChat extends SearchUserState {
  String groupId;

  SearchUserGroupChat(this.groupId) : super([groupId]);

  @override
  String toString() => 'SearchUserGroupChat $groupId';
}

class SearchUserCreatingGroup extends SearchUserState {
  @override
  String toString() => 'CreatingGroup';
}
