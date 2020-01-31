import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat/src/typing_users/typing_users_state.dart';

void main() {
  test(
      'TypingUsersList toString method should return : "TypingUsersList [usersNames]"',
      () {
    final List<String> usersNames = ['Name1', 'Name2'];
    final TypingUsersList typingUsersList = TypingUsersList(usersNames);
    expect(typingUsersList.toString(), 'TypingUsersList $usersNames');
  });

  test(
      'TypingUsersInitial toString method should return : "TypingUsersInitial"',
      () {
    final TypingUsersInitial typingUsersInitial = TypingUsersInitial();
    expect(typingUsersInitial.toString(), 'TypingUsersInitial');
  });
}
