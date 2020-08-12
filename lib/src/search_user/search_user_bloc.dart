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
        assert(groupManagementBloc != null),
        super(SearchUserInitial());
  ChatService chatService;
  GroupManagementBloc groupManagementBloc;

  @override
  Stream<SearchUserState> mapEventToState(
    SearchUserEvent event,
  ) async* {
    if (event is SearchUserWithName) {
      if (event.searchName.isEmpty) {
        yield const SearchUserList({});
      } else {
        final Map<String, String> users =
            await chatService.searchUsersByName(event.searchName);
        yield SearchUserList(users);
      }
    } else if (event is ChatWithUser) {
      yield const SearchUserList({});
      final String groupId =
          await chatService.getDuoGroupId(event.currentUid, event.uid);
      if (groupId != null) {
        groupManagementBloc.add(NavigateToGroup(groupId));
      } else {
        groupManagementBloc.add(CreateDuoGroup(event.currentUid, event.uid));
      }
    }
  }
}
