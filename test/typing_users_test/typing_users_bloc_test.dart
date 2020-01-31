import 'dart:async';

import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/typing_users/typing_users.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockChatService extends Mock implements ChatService {}

void main() {
  ChatService chatService;
  TypingUsersBloc typingUsersBloc;

  setUp(() {
    chatService = MockChatService();
    when(chatService.typingUsers('groupId')).thenAnswer(
      (_) => Future.value(
        Stream.fromIterable([]),
      ),
    );
    typingUsersBloc = TypingUsersBloc(
      chatService,
      'groupId',
    );
  });

  test('initial state is correct', () {
    expect(typingUsersBloc.initialState, TypingUsersInitial());
  });

  test('dispose does not emit new states', () {
    expectLater(
      typingUsersBloc.state,
      emitsInOrder([TypingUsersInitial(), emitsDone]),
    );
    typingUsersBloc.close();
  });

  test('emits [TypingUsersInitial, TypingUsersList] when users are Typing', () {
    const List<String> names = ['testname1', 'testname2'];
    expectLater(
      typingUsersBloc.state,
      emitsInOrder([
        TypingUsersInitial(),
        const TypingUsersList(names),
      ]),
    );
    typingUsersBloc.add(const TypingUsersEvent(names));
  });
  test('emits [TypingUsersInitial, TypingUsersList] when nobody is typing ',
      () {
    const List<String> names = ['testname1', 'testname2'];
    expectLater(
      typingUsersBloc.state,
      emitsInOrder([TypingUsersInitial(), const TypingUsersList(names)]),
    );
    typingUsersBloc.add(const TypingUsersEvent(names));
  });
}
