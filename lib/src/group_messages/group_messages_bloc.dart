import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/group_messages/group_messages.dart';

class GroupMessagesBloc extends Bloc<GroupMessagesEvent, GroupMessagesState> {
  GroupMessagesBloc(this.chatService, this.groupId) {
    _subMessages = chatService.streamOfMessages(groupId).listen((messages) {
      dispatch(SyncMessagesEvent(messages));
    }, onError: (error) {
      dispatch(ErrorSyncMessagesEvent());
    });
  }
  ChatService chatService;
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
