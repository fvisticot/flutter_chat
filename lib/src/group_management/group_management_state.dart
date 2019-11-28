import 'package:equatable/equatable.dart';

abstract class GroupManagementState extends Equatable {
  const GroupManagementState();
}

class GroupManagementInitialState extends GroupManagementState {
  @override
  String toString() => 'GroupManagementInitialState';
  @override
  List<Object> get props => [];
}

class NavigateToGroupState extends GroupManagementState {
  const NavigateToGroupState(this.groupId) : assert(groupId != null);
  final String groupId;

  @override
  String toString() => 'NavigateToGroupState{groupId: $groupId}';
  @override
  List<Object> get props => [groupId];
}

class CreatingGroupState extends GroupManagementState {
  @override
  String toString() => 'CreatingGroupState';
  @override
  List<Object> get props => [];
}
