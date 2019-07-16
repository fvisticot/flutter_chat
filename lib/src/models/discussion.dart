import 'package:meta/meta.dart';

class Discussion {
  Discussion({
    @required this.groupId,
    @required this.title,
    @required this.lastMessage,
  });
  final String groupId;
  final String title;
  final String lastMessage;

  @override
  String toString() =>
      'Discussion{groupId: $groupId, title: $title, lastMessage: $lastMessage}';
}
