import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';

import 'discussions_list.dart';

class DiscussionsListBloc
    extends Bloc<DiscussionsListEvent, DiscussionsListState> {
  FirebaseRepository firebaseRepository;
  String userId;

  DiscussionsListBloc(this.firebaseRepository, this.userId)
      : assert(firebaseRepository != null),
        assert(userId != null);

  @override
  DiscussionsListState get initialState => DiscussionsInitial();

  @override
  Stream<DiscussionsListState> mapEventToState(
      DiscussionsListEvent event) async* {
    if (event is GetDiscussionsList) {
      yield DiscussionsLoading();
      Map<String, String> discussions;
      yield DiscussionsSuccess(discussions);
    }
  }
}
