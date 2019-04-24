import 'package:flutter_chat/src/user_presence/user_presence_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UserPresenceEvent with null parameter should throw assertion', () {
    expect(
        () => UserPresenceEvent(null), throwsA(isInstanceOf<AssertionError>()));
  });

  test(
      'UserPresenceEvent toString method should return : "UserPresenceEvent [isOnline]"',
      () {
    bool isOnline = true;
    UserPresenceEvent userPresenceEvent = UserPresenceEvent(isOnline);
    expect(userPresenceEvent.toString(), 'UserPresenceEvent $isOnline');
  });
}
