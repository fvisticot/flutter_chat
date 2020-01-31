import 'package:flutter_chat/src/models/group.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Group constructor with all parameters', () {
    const String id = 'groupId';
    const String title = 'groupTitle';
    final Map<String, String> users = {'userId': 'userName'};

    final Group group = Group(id, users, title: title);

    expect(group.id, id);
    expect(group.users, users);
    expect(group.title, title);
  });

  test('Group constructor without title', () {
    const String id = 'groupId';
    final Map<String, String> users = {'userId': 'userName'};

    final Group group = Group(id, users);

    expect(group.id, id);
    expect(group.users, users);
    expect(group.title, null);
  });

  test('Group.toString with all parameters', () {
    const String id = 'groupId';
    const String title = 'groupTitle';
    final Map<String, String> users = {'userId': 'userName'};

    final Group group = Group(id, users, title: title);

    expect(group.toString(), 'Group{id: $id, users: $users, title: $title}');
  });

  test('Group.toString without title', () {
    const String id = 'groupId';
    final Map<String, String> users = {'userId': 'userName'};

    final Group group = Group(id, users);

    expect(group.toString(), 'Group{id: $id, users: $users, title: ${null}}');
  });
}
