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
    if (event is SearchUserEvent) {
      if (event.searchName.length == 0) {
        yield SearchUserList({});
      } else {
        final Map<String, String> users =
            await firebaseRepository.searchUsersByName(event.searchName);
        yield SearchUserList(users);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
