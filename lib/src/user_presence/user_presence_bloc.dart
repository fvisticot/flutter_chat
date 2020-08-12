import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'user_presence.dart';

class UserPresenceBloc extends Bloc<UserPresenceEvent, UserPresenceState> {
  UserPresenceBloc(this.chatService, this.userId) : super(UserPresenceLoading()) {
    _subUserPresence =
        chatService.userPresenceStream(userId).listen((isOnline) {
      add(UserPresenceEvent(isOnline: isOnline));
    });
  }
  ChatService chatService;
  String userId;
  StreamSubscription _subUserPresence;

  @override
  Stream<UserPresenceState> mapEventToState(UserPresenceEvent event) async* {
    if (event is UserPresenceEvent) {
      yield UserPresenceIsOnline(isOnline: event.isOnline);
    }
  }

  @override
  Future<void> close() async {
    _subUserPresence?.cancel();
    super.close();
  }
}
