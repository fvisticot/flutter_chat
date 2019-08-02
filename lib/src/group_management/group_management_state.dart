import 'package:equatable/equatable.dart';

abstract class GroupManagementState extends Equatable {
  GroupManagementState([List props = const []]) : super(props);
}

class GroupManagementInitialState extends GroupManagementState {
  @override
  String toString() => 'GroupManagementInitialState';
}

class NavigateToGroupState extends GroupManagementState {
  NavigateToGroupState(this.groupId)
      : assert(groupId != null),
        super([groupId]);
  final String groupId;

  @override
  String toString() => 'NavigateToGroupState $groupId';
}

class CreatingGroupState extends GroupManagementState {
  @override
  String toString() => 'CreatingGroupState';
}
