import 'dart:async';
import 'package:bloc/bloc.dart';
import 'group_messages.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';

class GroupMessagesBloc extends Bloc<GroupMessagesEvent, GroupMessagesState> {
  FirebaseRepository firebaseRepository;
  String groupId;
  StreamSubscription _subMessages;

  GroupMessagesBloc(this.firebaseRepository, this.groupId) {
    _subMessages = firebaseRepository.streamOfMessages(groupId).listen((messages) {
      dispatch(SyncMessagesEvent(messages));
    });
  }

  @override
  GroupMessagesState get initialState => GroupMessagesInitial();

  @override
  Stream<GroupMessagesState> mapEventToState(
      GroupMessagesEvent event,
  ) async* {
    if (event is SyncMessagesEvent) {
      yield GroupMessagesSuccess(event.messages);
    }
  }

  @override
  void dispose() {
    _subMessages.cancel();
    super.dispose();
  }
}
