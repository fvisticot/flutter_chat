import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/repositories/chat_firebase_repository.dart';
import 'user_presence.dart';

class UserPresenceBloc extends Bloc<UserPresenceEvent, UserPresenceState> {
  UserPresenceBloc(this.firebaseRepository, this.userId) {
    _subUserPresence =
        firebaseRepository.userPresence(userId).listen((isOnline) {
      dispatch(UserPresenceEvent(isOnline: isOnline));
    });
  }
  ChatFirebaseRepository firebaseRepository;
  String userId;
  StreamSubscription _subUserPresence;

  @override
  UserPresenceState get initialState => UserPresenceLoading();

  @override
  Stream<UserPresenceState> mapEventToState(UserPresenceEvent event) async* {
    if (event is UserPresenceEvent) {
      yield UserPresenceIsOnline(isOnline: event.isOnline);
    }
  }

  @override
  void dispose() {
    _subUserPresence.cancel();
    super.dispose();
  }
}
