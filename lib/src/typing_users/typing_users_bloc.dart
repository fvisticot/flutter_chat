import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/repositories/chat_firebase_repository.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/typing_users/typing_users_event.dart';
import 'package:flutter_chat/src/typing_users/typing_users_state.dart';

class TypingUsersBloc extends Bloc<TypingUsersEvent, TypingUsersState> {
  TypingUsersBloc(this.firebaseRepository, this.groupId, this.currentUser) {
    _subTypingUsers = firebaseRepository
        .typingUsers(groupId, currentUser)
        .listen((usersNames) {
      dispatch(TypingUsersEvent(usersNames));
    });
  }
  ChatFirebaseRepository firebaseRepository;
  String groupId;
  User currentUser;
  StreamSubscription _subTypingUsers;

  @override
  TypingUsersState get initialState => TypingUsersInitial();

  @override
  Stream<TypingUsersState> mapEventToState(TypingUsersEvent event) async* {
    if (event is TypingUsersEvent) {
      yield TypingUsersList(event.usersNames);
    }
  }

  @override
  void dispose() {
    _subTypingUsers.cancel();
    super.dispose();
  }
}
