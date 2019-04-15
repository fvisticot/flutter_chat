import 'dart:async';
import 'package:bloc/bloc.dart';
import 'typing_users.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';
import 'package:flutter_chat/src/models/user.dart';

class TypingUsersBloc extends Bloc<TypingUsersEvent, TypingUsersState> {
  FirebaseRepository firebaseRepository;
  String groupId;
  User currentUser;
  StreamSubscription _subTypingUsers;

  TypingUsersBloc(this.firebaseRepository, this.groupId, this.currentUser) {
    _subTypingUsers = firebaseRepository.typingUsers(groupId, currentUser).listen((usersNames) {
      dispatch(TypingUsersEvent(usersNames));
    });
  }

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