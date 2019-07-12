import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/repositories/chat_firebase_repository.dart';

import 'search_user.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  SearchUserBloc(
    this.firebaseRepository,
    this.groupManagementBloc,
  )   : assert(firebaseRepository != null),
        assert(groupManagementBloc != null);
  ChatFirebaseRepository firebaseRepository;
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
            await firebaseRepository.searchUsersByName(event.searchName);
        yield SearchUserList(users);
      }
    } else if (event is ChatWithUser) {
      yield SearchUserList({});
      final String groupId =
          await firebaseRepository.getDuoGroupId(event.currentUid, event.uid);
      if (groupId != null) {
        groupManagementBloc.dispatch(NavigateToGroup(groupId));
      } else {
        groupManagementBloc
            .dispatch(CreateDuoGroup(event.currentUid, event.uid));
      }
    }
  }
}
