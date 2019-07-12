import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat/src/typing_users/typing_users_event.dart';

void main() {
  test('TypingUsersEvent with null parameter should throw assertion', () {
    expect(
        () => TypingUsersEvent(null), throwsA(isInstanceOf<AssertionError>()));
  });

  test(
      'TypingUsersEvent toString method should return : "TypingUsersEvent [usersNames]"',
      () {
    final List<String> usersNames = ['Name1', 'Name2'];
    final TypingUsersEvent typingUsersEvent = TypingUsersEvent(usersNames);
    expect(typingUsersEvent.toString(), 'TypingUsersEvent $usersNames');
  });
}
