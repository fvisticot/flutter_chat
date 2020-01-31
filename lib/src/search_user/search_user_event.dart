import 'package:equatable/equatable.dart';

abstract class SearchUserEvent extends Equatable {
  const SearchUserEvent();
}

class SearchUserWithName extends SearchUserEvent {
  const SearchUserWithName(this.searchName) : assert(searchName != null);
  final String searchName;

  @override
  String toString() => 'SearchUserWithName{search: $searchName}';
  @override
  List<Object> get props => [searchName];
}

class ChatWithUser extends SearchUserEvent {
  const ChatWithUser(this.currentUid, this.uid)
      : assert(currentUid != null),
        assert(uid != null);
  final String currentUid;
  final String uid;

  @override
  String toString() => 'ChatWithUser{currentUid : $currentUid, uid : $uid}';
  @override
  List<Object> get props => [currentUid, uid];
}
