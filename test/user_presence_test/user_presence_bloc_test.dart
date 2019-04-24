import 'package:flutter_chat/src/repositories/firebase_repository.dart';
import 'package:flutter_chat/src/user_presence/user_presence.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseRepository extends Mock implements FirebaseRepository {}

void main() {
  FirebaseRepository firebaseRepository;
  UserPresenceBloc userPresenceBloc;

  setUp(() {
    firebaseRepository = MockFirebaseRepository();
    when(firebaseRepository.userPresence(any))
        .thenAnswer((_) => Stream.empty());
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
      emitsInOrder([UserPresenceLoading(), UserPresenceIsOnline(true)]),
    );
    userPresenceBloc.dispatch(UserPresenceEvent(true));
  });

  test(
      'emits [UserPresenceLoading, UserPresenceIsOnline(fasle)] when UserPresenceEvent(false)',
      () {
    expectLater(
      userPresenceBloc.state,
      emitsInOrder([UserPresenceLoading(), UserPresenceIsOnline(false)]),
    );
    userPresenceBloc.dispatch(UserPresenceEvent(false));
  });
}
