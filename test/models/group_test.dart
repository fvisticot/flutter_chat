import 'package:flutter_chat/src/models/group.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Group constructor with all parameters', () {
    String id = 'groupId';
    String title = 'groupTitle';
    Map<String, String> users = {"userId": "userName"};

    Group group = Group(id, users, title: title);

    expect(group.id, id);
    expect(group.users, users);
    expect(group.title, title);
  });

  test('Group constructor without title', () {
    String id = 'groupId';
    Map<String, String> users = {"userId": "userName"};

    Group group = Group(id, users);

    expect(group.id, id);
    expect(group.users, users);
    expect(group.title, null);
  });

  test('Group.toString with all parameters', () {
    String id = 'groupId';
    String title = 'groupTitle';
    Map<String, String> users = {"userId": "userName"};

    Group group = Group(id, users, title: title);

    expect(group.toString(), 'Group{id: $id, users: $users, title: $title}');
  });

  test('Group.toString without title', () {
    String id = 'groupId';
    Map<String, String> users = {"userId": "userName"};

    Group group = Group(id, users);

    expect(group.toString(), 'Group{id: $id, users: $users, title: ${null}}');
  });
}
