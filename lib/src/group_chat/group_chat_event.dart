import 'package:equatable/equatable.dart';

abstract class GroupChatEvent extends Equatable {
  const GroupChatEvent();
}

class GroupChatStarted extends GroupChatEvent {
  const GroupChatStarted(this.groupId) : assert(groupId != null);
  final String groupId;

  @override
  String toString() => 'GroupChatStarted{groupId: $groupId}';
  @override
  List<Object> get props => [groupId];
}
