import 'package:flutter_chat/src/repositories/chat_firebase_repository.dart';
import 'package:flutter_chat/src/user_presence/user_presence.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseRepository extends Mock implements ChatFirebaseRepository {}

void main() {
  ChatFirebaseRepository firebaseRepository;
  UserPresenceBloc userPresenceBloc;

  setUp(() {
    firebaseRepository = MockFirebaseRepository();
    when(firebaseRepository.userPresence(any))
        .thenAnswer((_) => const Stream.empty());
    userPresenceBloc = UserPresenceBloc(firebaseRepository, any);
  });

  test('initial state is UserPresenceLoading', () {
    expect(userPresenceBloc.initialState, UserPresenceLoading());
  });

  test(
      'emits [UserPresenceLoading, UserPresenceIsOnline(true)] when UserPresenceEvent(true)',
      () {
    expectLater(
      userPresenceBloc.state,
      emitsInOrder(
          [UserPresenceLoading(), UserPresenceIsOnline(isOnline: true)]),
    );
    userPresenceBloc.dispatch(UserPresenceEvent(isOnline: true));
  });

  test(
      'emits [UserPresenceLoading, UserPresenceIsOnline(fasle)] when UserPresenceEvent(false)',
      () {
    expectLater(
      userPresenceBloc.state,
      emitsInOrder(
          [UserPresenceLoading(), UserPresenceIsOnline(isOnline: false)]),
    );
    userPresenceBloc.dispatch(UserPresenceEvent(isOnline: false));
  });
}
