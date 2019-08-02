import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/models/group.dart';
import 'group_chat.dart';

class GroupChatBloc extends Bloc<GroupChatEvent, GroupChatState> {
  GroupChatBloc(
    this.chatService,
    this.groupId,
  )   : assert(chatService != null),
        assert(groupId != null);
  final ChatService chatService;
  final String groupId;

  @override
  GroupChatState get initialState => GroupChatInitial();

  @override
  Stream<GroupChatState> mapEventToState(GroupChatEvent event) async* {
    if (event is GroupChatStarted) {
      try {
        yield GroupChatLoading();
        final Group group = await chatService.getGroupInfo(event.groupId);
        yield GroupChatSuccess(group);
      } catch (e) {
        yield GroupChatError();
      }
    }
  }
}
