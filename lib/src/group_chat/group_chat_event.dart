import 'package:equatable/equatable.dart';

abstract class GroupChatEvent extends Equatable {
  GroupChatEvent([List props = const []]) : super(props);
}

class GroupChatStarted extends GroupChatEvent {
  GroupChatStarted(this.groupId)
      : assert(groupId != null),
        super([groupId]);
  final String groupId;

  @override
  String toString() => 'GroupChatStarted';
}
