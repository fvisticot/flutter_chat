import 'package:flutter_chat/src/user_presence/user_presence_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UserPresenceEvent with null parameter should throw assertion', () {
    expect(() => UserPresenceEvent(isOnline: null),
        throwsA(isInstanceOf<AssertionError>()));
  });

  test(
      'UserPresenceEvent toString method should return : "UserPresenceEvent [isOnline]"',
      () {
    const bool isOnline = true;
    const UserPresenceEvent userPresenceEvent =
        UserPresenceEvent(isOnline: isOnline);
    expect(userPresenceEvent.toString(), 'UserPresenceEvent $isOnline');
  });
}
