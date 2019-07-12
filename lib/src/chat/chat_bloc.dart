import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/chat/chat_event.dart';
import 'package:flutter_chat/src/chat/chat_state.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/repositories/chat_firebase_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this.firebaseRepository) : assert(firebaseRepository != null);
  ChatFirebaseRepository firebaseRepository;

  @override
  ChatState get initialState => ChatUninitialized();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatStarted) {
      yield ChatLoading();
      final User user = await firebaseRepository.initChat();
      yield ChatInitialized(user);
    }
  }
}
