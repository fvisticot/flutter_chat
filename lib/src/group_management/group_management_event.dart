import 'package:equatable/equatable.dart';

class GroupManagementEvent extends Equatable {
  GroupManagementEvent([List props = const []]) : super(props);
}

class NavigateToGroup extends GroupManagementEvent {
  String groupId;

  NavigateToGroup(this.groupId)
      : assert(groupId != null),
        super([groupId]);

  @override
  String toString() => 'NavigateToGroup $groupId';
}

class CreateDuoGroup extends GroupManagementEvent {
  String currentUid;
  String uid;

  CreateDuoGroup(this.currentUid, this.uid)
      : assert(currentUid != null),
        assert(uid != null),
        super([currentUid, uid]);

  @override
  String toString() =>
      'CreateDuoGroup current user id : $currentUid, other user id : $uid';
}
