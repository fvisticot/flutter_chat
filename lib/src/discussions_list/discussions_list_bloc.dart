import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';

import 'discussions_list.dart';

class DiscussionsListBloc
    extends Bloc<DiscussionsListEvent, DiscussionsListState> {
  FirebaseRepository firebaseRepository;
  GroupManagementBloc groupManagementBloc;
  String userId;
  StreamSubscription _subDiscussions;

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
