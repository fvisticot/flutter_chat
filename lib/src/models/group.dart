import 'package:flutter_chat/src/models/user.dart';

class Group {
  String id;
  String title;
  List<User> users;

  Group(this.id, this.users, {this.title});

  Map<String, dynamic> toJson() => {
        'title': title,
      };

  @override
  String toString() {
    return 'Group{id: $id, users: $users, title: $title}';
  }
}
