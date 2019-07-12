import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/repositories/chat_firebase_repository.dart';

import 'discussions_list.dart';

class DiscussionsListBloc
    extends Bloc<DiscussionsListEvent, DiscussionsListState> {
  DiscussionsListBloc(
      this.firebaseRepository, this.groupManagementBloc, this.userId)
      : assert(firebaseRepository != null),
        assert(groupManagementBloc != null),
        assert(userId != null) {
    _subDiscussions = firebaseRepository
        .streamOfUserDiscussions(userId)
        .listen((discussions) {
      dispatch(SyncDiscussionsList(discussions));
    });
  }
  ChatFirebaseRepository firebaseRepository;
  GroupManagementBloc groupManagementBloc;
  String userId;
  StreamSubscription _subDiscussions;

  @override
  DiscussionsListState get initialState => DiscussionsInitial();

  @override
  Stream<DiscussionsListState> mapEventToState(
      DiscussionsListEvent event) async* {
    if (event is SyncDiscussionsList) {
      yield DiscussionsSuccess(event.discussions);
    }
  }

  @override
  void dispose() {
    _subDiscussions.cancel();
    super.dispose();
  }
}
