import 'package:equatable/equatable.dart';

abstract class SearchUserState extends Equatable {
  const SearchUserState();
}

class SearchUserInitial extends SearchUserState {
  @override
  String toString() => 'SearchUserInitial';
  @override
  List<Object> get props => [];
}

class SearchUserList extends SearchUserState {
  const SearchUserList(this.users);
  final Map<String, String> users;

  @override
  String toString() => 'SearchUserList{users: $users}';
  @override
  List<Object> get props => [users];
}

class SearchUserGroupChat extends SearchUserState {
  const SearchUserGroupChat(this.groupId);
  final String groupId;

  @override
  String toString() => 'SearchUserGroupChat{goupid: $groupId}';
  @override
  List<Object> get props => [groupId];
}

class SearchUserCreatingGroup extends SearchUserState {
  @override
  String toString() => 'CreatingGroup';
  @override
  List<Object> get props => [];
}
