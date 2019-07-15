import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/chat/chat_event.dart';
import 'package:flutter_chat/src/chat/chat_state.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/models/user.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this.chatService) : assert(chatService != null);
  ChatService chatService;

  @override
  ChatState get initialState => ChatUninitialized();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatStarted) {
      yield ChatLoading();
      final User user = await chatService.initChat();
      yield ChatInitialized(user);
    }
  }
}
