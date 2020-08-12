import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/group_messages/group_messages.dart';

class GroupMessagesBloc extends Bloc<GroupMessagesEvent, GroupMessagesState> {
  GroupMessagesBloc(this.chatService, this.groupId) : super(GroupMessagesInitial()) {
    _subMessages = chatService.streamOfMessages(groupId).listen((messages) {
      add(SyncMessagesEvent(messages));
    }, onError: (error) {
      add(ErrorSyncMessagesEvent());
    });
  }
  ChatService chatService;
  String groupId;
  StreamSubscription _subMessages;

  @override
  Stream<GroupMessagesState> mapEventToState(
    GroupMessagesEvent event,
  ) async* {
    if (event is SyncMessagesEvent) {
      yield GroupMessagesSuccess(event.messages);
    } else if (event is ErrorSyncMessagesEvent) {
      yield const GroupMessagesError(error: 'Error synchronizing messages');
    }
  }

  @override
  Future<void> close() async {
    _subMessages?.cancel();
    super.close();
  }
}
