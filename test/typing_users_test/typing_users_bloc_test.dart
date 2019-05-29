import 'dart:async';

import 'package:flutter_chat/src/repositories/firebase_repository.dart';
import 'package:flutter_chat/src/typing_users/typing_users.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseRepository extends Mock implements FirebaseRepository {}

void main() {
  FirebaseRepository firebaseRepository;
  TypingUsersBloc typingUsersBloc;

  setUp(() {
    firebaseRepository = MockFirebaseRepository();
    when(firebaseRepository.typingUsers(any, any))
        .thenAnswer((_) => Stream.fromIterable([]));
    typingUsersBloc = TypingUsersBloc(firebaseRepository, any, any);
  });

  test('initial state is correct', () {
    expect(typingUsersBloc.initialState, TypingUsersInitial());
  });

  test('dispose does not emit new states', () {
    expectLater(
      typingUsersBloc.state,
      emitsInOrder([TypingUsersInitial(), emitsDone]),
    );
    typingUsersBloc.dispose();
  });

  test('emits [TypingUsersInitial, TypingUsersList] when users are Typing', () {
    expectLater(
      typingUsersBloc.state,
      emitsInOrder([
        TypingUsersInitial(),
        TypingUsersList(['testName']),
      ]),
    );
    typingUsersBloc.dispatch(TypingUsersEvent(['testName']));
  });

  /*test('emits [TypingUsersInitial, TypingUsersList] when users are Typing', () {
    expectLater(
      typingUsersBloc.state,
      emitsInOrder([
        TypingUsersInitial(),
        TypingUsersList(['testName']),
      ]),
    ).then((_) {
      expectLater(
        typingUsersBloc.state,
        emitsInOrder([emitsDone]),
      );
      typingUsersBloc.dispose();
    });
    typingUsersBloc.dispatch(TypingUsersEvent(['testName']));
  });*/

  test('emits [TypingUsersInitial, TypingUsersList] when nobody is typing ',
      () {
    expectLater(
      typingUsersBloc.state,
      emitsInOrder([TypingUsersInitial(), TypingUsersList([])]),
    );
    typingUsersBloc.dispatch(TypingUsersEvent([]));
  });
}
