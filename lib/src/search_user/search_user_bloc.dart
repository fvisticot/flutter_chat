import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';

import 'search_user.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  FirebaseRepository firebaseRepository;

  SearchUserBloc(this.firebaseRepository) : assert(firebaseRepository != null);

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
        yield SearchUserGroupChat(groupId);
      } else {
        yield SearchUserCreatingGroup();
        groupId = await firebaseRepository.createDuoGroup(
            event.currentUid, event.uid);
        yield SearchUserGroupChat(groupId);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
