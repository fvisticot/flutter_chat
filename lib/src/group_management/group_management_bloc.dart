import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';

class GroupManagementBloc
    extends Bloc<GroupManagementEvent, GroupManagementState> {
  GroupManagementBloc(this.chatService) :
        assert(chatService != null),
        super(GroupManagementInitialState());
  ChatService chatService;

  @override
  Stream<GroupManagementState> mapEventToState(
      GroupManagementEvent event) async* {
    if (event is NavigateToGroup) {
      yield NavigateToGroupState(event.groupId);
      yield GroupManagementInitialState();
    }
    if (event is CreateDuoGroup) {
      yield CreatingGroupState();
      final String groupId =
          await chatService.createDuoGroup(event.currentUid, event.uid);
      yield NavigateToGroupState(groupId);
    }
  }
}
