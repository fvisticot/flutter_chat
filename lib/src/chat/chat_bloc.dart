import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'chat_state.dart';
import 'chat_event.dart';
import '../repositories/firebase_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  FirebaseRepository firebaseRepository;

  ChatBloc(this.firebaseRepository)
  : assert (firebaseRepository != null);

  @override
  ChatState get initialState => ChatUninitialized();

  @override
  Stream<ChatState> mapEventToState(
      ChatEvent event) async* {
    if (event is ChatStarted) {
      yield ChatLoading();
      User user = await firebaseRepository.initChat(event.userName);
      yield ChatInitialized(user);
    }
  }

}
