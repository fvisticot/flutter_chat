import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/search_user/search_user.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  SearchUserBloc(
    this.chatService,
    this.groupManagementBloc,
  )   : assert(chatService != null),
        assert(groupManagementBloc != null);
  ChatService chatService;
  GroupManagementBloc groupManagementBloc;

  @override
  SearchUserState get initialState => SearchUserInitial();

  @override
  Stream<SearchUserState> mapEventToState(
    SearchUserEvent event,
  ) async* {
    if (event is SearchUserWithName) {
      if (event.searchName.isEmpty) {
        yield SearchUserList({});
      } else {
        final Map<String, String> users =
            await chatService.searchUsersByName(event.searchName);
        yield SearchUserList(users);
      }
    } else if (event is ChatWithUser) {
      yield SearchUserList({});
      final String groupId =
          await chatService.getDuoGroupId(event.currentUid, event.uid);
      if (groupId != null) {
        groupManagementBloc.dispatch(NavigateToGroup(groupId));
      } else {
        groupManagementBloc
            .dispatch(CreateDuoGroup(event.currentUid, event.uid));
      }
    }
  }
}
