import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/flutter_chat.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatState get initialState => ChatState.initial();

  /*
  void onSettingsButtonPressed({String userName, String password}) {
    dispatch(
      SettingsButtonPressed(
        userName: userName,
        password: password,
      ),
    );
  }

  void onSettingsSuccess() {
    dispatch(LoggedIn());
  }
  */

  @override
  Stream<ChatState> mapEventToState(
    ChatState currentState,
    ChatEvent event,
  ) async* {}
}
