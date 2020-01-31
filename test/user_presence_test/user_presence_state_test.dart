import 'package:flutter_chat/src/user_presence/user_presence_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UserPresenceIsOnline with null parameter should throw assertion', () {
    expect(() => UserPresenceIsOnline(isOnline: null),
        throwsA(isInstanceOf<AssertionError>()));
  });

  test(
      'UserPresenceIsOnline toString method should return : "UserPresenceIsOnline [isOnline]"',
      () {
    const bool isOnline = true;
    const UserPresenceIsOnline userPresenceIsOnline =
        UserPresenceIsOnline(isOnline: isOnline);
    expect(userPresenceIsOnline.toString(), 'UserPresenceIsOnline $isOnline');
  });

  test(
      'UserPresenceLoading toString method should return : "UserPresenceLoading"',
      () {
    final UserPresenceLoading userPresenceLoading = UserPresenceLoading();
    expect(userPresenceLoading.toString(), 'UserPresenceLoading');
  });
}
