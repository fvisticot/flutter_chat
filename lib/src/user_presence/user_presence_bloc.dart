import 'dart:async';
import 'package:bloc/bloc.dart';
import 'user_presence.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';

class UserPresenceBloc extends Bloc<UserPresenceEvent, UserPresenceState> {
  FirebaseRepository firebaseRepository;
  String userId;
  StreamSubscription _subUserPresence;

  UserPresenceBloc(this.firebaseRepository, this.userId) {
    _subUserPresence = firebaseRepository.userPresence(userId).listen((isOnline) {
      dispatch(UserPresenceEvent(isOnline));
    });
  }

  @override
  UserPresenceState get initialState => UserPresenceLoading();

  @override
  Stream<UserPresenceState> mapEventToState(UserPresenceEvent event) async* {
    if (event is UserPresenceEvent) {
      yield UserPresenceIsOnline(event.isOnline);
    }
  }


  @override
  void dispose() {
    _subUserPresence.cancel();
    super.dispose();
  }
}