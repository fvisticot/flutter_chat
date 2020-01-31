import 'package:equatable/equatable.dart';

abstract class GroupManagementEvent extends Equatable {
  const GroupManagementEvent();
}

class NavigateToGroup extends GroupManagementEvent {
  const NavigateToGroup(this.groupId) : assert(groupId != null);
  final String groupId;

  @override
  String toString() => 'NavigateToGroup{groupId: $groupId}';
  @override
  List<Object> get props => [groupId];
}

class CreateDuoGroup extends GroupManagementEvent {
  const CreateDuoGroup(this.currentUid, this.uid)
      : assert(currentUid != null),
        assert(uid != null);
  final String currentUid;
  final String uid;

  @override
  String toString() => 'CreateDuoGroup{currentId: $currentUid, uid: $uid}';
  @override
  List<Object> get props => [currentUid, uid];
}
