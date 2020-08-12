import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/typing_users/typing_users_event.dart';
import 'package:flutter_chat/src/typing_users/typing_users_state.dart';

class TypingUsersBloc extends Bloc<TypingUsersEvent, TypingUsersState> {
  TypingUsersBloc(this.chatService, this.groupId) : super(TypingUsersInitial()) {
    chatService.typingUsers(groupId).then((typingUsersStream) {
      _subTypingUsers = typingUsersStream.listen((usersNames) {
        add(TypingUsersEvent(usersNames));
      });
    });
  }
  ChatService chatService;
  String groupId;
  StreamSubscription _subTypingUsers;

  @override
  Stream<TypingUsersState> mapEventToState(TypingUsersEvent event) async* {
    if (event is TypingUsersEvent) {
      yield TypingUsersList(event.usersNames);
    }
  }

  @override
  Future<void> close() async {
    _subTypingUsers?.cancel();
    super.close();
  }
}
