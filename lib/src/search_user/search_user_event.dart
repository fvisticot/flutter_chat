import 'package:equatable/equatable.dart';

class SearchUserEvent extends Equatable {
  SearchUserEvent([List props = const []]) : super(props);
}

class SearchUserWithName extends SearchUserEvent {
  String searchName;

  SearchUserWithName(this.searchName)
      : assert(searchName != null),
        super([searchName]);

  @override
  String toString() => 'SearchUserWithName $searchName';
}

class ChatWithUser extends SearchUserEvent {
  String currentUid;
  String uid;

  ChatWithUser(this.currentUid, this.uid)
      : assert(currentUid != null),
        assert(uid != null),
        super([currentUid, uid]);

  @override
  String toString() =>
      'ChatWithUser current user id : $currentUid, other user id : $uid';
}
