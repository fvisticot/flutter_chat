import 'package:equatable/equatable.dart';

abstract class GroupChatEvent extends Equatable {
  GroupChatEvent([List props = const []]) : super(props);
}

class GroupChatStarted extends GroupChatEvent {
  String groupId;

  GroupChatStarted(this.groupId)
      : assert(groupId != null),
        super([groupId]);

  @override
  String toString() => 'GroupChatStarted';
}
