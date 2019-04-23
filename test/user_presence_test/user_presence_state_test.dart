import 'package:flutter_chat/src/user_presence/user_presence_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UserPresenceIsOnline with null parameter should throw assertion', () {
    expect(() => UserPresenceIsOnline(null),
        throwsA(isInstanceOf<AssertionError>()));
  });

  test(
      'UserPresenceIsOnline toString method should return : "UserPresenceIsOnline [isOnline]"',
      () {
    bool isOnline = true;
    UserPresenceIsOnline userPresenceIsOnline = UserPresenceIsOnline(isOnline);
    expect(userPresenceIsOnline.toString(), 'UserPresenceIsOnline $isOnline');
  });

  test(
      'UserPresenceLoading toString method should return : "UserPresenceLoading"',
      () {
    UserPresenceLoading userPresenceLoading = UserPresenceLoading();
    expect(userPresenceLoading.toString(), 'UserPresenceLoading');
  });
}
