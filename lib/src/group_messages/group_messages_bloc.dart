import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/repositories/chat_firebase_repository.dart';
import 'group_messages.dart';

class GroupMessagesBloc extends Bloc<GroupMessagesEvent, GroupMessagesState> {
  GroupMessagesBloc(this.firebaseRepository, this.groupId) {
    _subMessages =
        firebaseRepository.streamOfMessages(groupId).listen((messages) {
      dispatch(SyncMessagesEvent(messages));
    }, onError: (error) {
      dispatch(ErrorSyncMessagesEvent());
    });
  }
  ChatFirebaseRepository firebaseRepository;
  String groupId;
  StreamSubscription _subMessages;

  @override
  GroupMessagesState get initialState => GroupMessagesInitial();

  @override
  Stream<GroupMessagesState> mapEventToState(
    GroupMessagesEvent event,
  ) async* {
    if (event is SyncMessagesEvent) {
      yield GroupMessagesSuccess(event.messages);
    } else if (event is ErrorSyncMessagesEvent) {
      yield GroupMessagesError();
    }
  }

  @override
  void dispose() {
    _subMessages.cancel();
    super.dispose();
  }
}
