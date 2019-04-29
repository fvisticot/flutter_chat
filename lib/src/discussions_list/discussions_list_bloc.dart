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

  DiscussionsListBloc(
      this.firebaseRepository, this.groupManagementBloc, this.userId)
      : assert(firebaseRepository != null),
        assert(groupManagementBloc != null),
        assert(userId != null);

  @override
  DiscussionsListState get initialState => DiscussionsInitial();

  @override
  Stream<DiscussionsListState> mapEventToState(
      DiscussionsListEvent event) async* {
    if (event is GetDiscussionsList) {
      yield DiscussionsLoading();
      Map<String, dynamic> discussions =
          await firebaseRepository.getUserDiscussions(userId);
      yield DiscussionsSuccess(discussions);
    }
  }
}
