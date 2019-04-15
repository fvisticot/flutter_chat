import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat/src/typing_users/typing_users.dart';


void main() {
  test('TypingUsersEvent with null parameter throw assertion', (){
    expect(() => TypingUsersEvent(null), throwsA(isInstanceOf<AssertionError>()));
  });

  test('TypingUsersEvent with null parameter throw assertion', (){
    List<String> usersNames = ['Name1', 'Name2'];
    TypingUsersEvent typingUsersEvent = TypingUsersEvent(usersNames);
    expect(typingUsersEvent.toString(), 'TypingUsersEvent $usersNames');
  });
}