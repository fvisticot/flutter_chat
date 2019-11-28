import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/user_presence/user_presence.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockChatService extends Mock implements ChatService {}

void main() {
  MockChatService chatService;
  UserPresenceBloc userPresenceBloc;

  setUp(() {
    chatService = MockChatService();
    when(chatService.userPresenceStream(any))
        .thenAnswer((_) => const Stream.empty());
    userPresenceBloc = UserPresenceBloc(chatService, any);
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
          [UserPresenceLoading(), const UserPresenceIsOnline(isOnline: true)]),
    );
    userPresenceBloc.add(const UserPresenceEvent(isOnline: true));
  });

  test(
      'emits [UserPresenceLoading, UserPresenceIsOnline(fasle)] when UserPresenceEvent(false)',
      () {
    expectLater(
      userPresenceBloc.state,
      emitsInOrder(
          [UserPresenceLoading(), const UserPresenceIsOnline(isOnline: false)]),
    );
    userPresenceBloc.add(const UserPresenceEvent(isOnline: false));
  });
}
