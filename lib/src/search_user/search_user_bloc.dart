import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';

import 'search_user.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  FirebaseRepository firebaseRepository;
  GroupManagementBloc groupManagementBloc;

  SearchUserBloc(this.firebaseRepository, this.groupManagementBloc)
      : assert(firebaseRepository != null),
        assert(groupManagementBloc != null);

  @override
  SearchUserState get initialState => SearchUserInitial();

  @override
  Stream<SearchUserState> mapEventToState(
    SearchUserEvent event,
  ) async* {
    if (event is SearchUserWithName) {
      if (event.searchName.length == 0) {
        yield SearchUserList({});
      } else {
        final Map<String, String> users =
            await firebaseRepository.searchUsersByName(event.searchName);
        yield SearchUserList(users);
      }
    } else if (event is ChatWithUser) {
      yield SearchUserList({});
      String groupId =
          await firebaseRepository.getDuoGroupId(event.currentUid, event.uid);
      if (groupId != null) {
        groupManagementBloc.dispatch(NavigateToGroup(groupId));
      } else {
        groupManagementBloc
            .dispatch(CreateDuoGroup(event.currentUid, event.uid));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
