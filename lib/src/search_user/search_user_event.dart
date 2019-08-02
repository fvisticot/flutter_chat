import 'package:equatable/equatable.dart';

class SearchUserEvent extends Equatable {
  SearchUserEvent([List props = const []]) : super(props);
}

class SearchUserWithName extends SearchUserEvent {
  SearchUserWithName(this.searchName)
      : assert(searchName != null),
        super([searchName]);
  final String searchName;

  @override
  String toString() => 'SearchUserWithName $searchName';
}

class ChatWithUser extends SearchUserEvent {
  ChatWithUser(this.currentUid, this.uid)
      : assert(currentUid != null),
        assert(uid != null),
        super([currentUid, uid]);
  final String currentUid;
  final String uid;

  @override
  String toString() =>
      'ChatWithUser current user id : $currentUid, other user id : $uid';
}
