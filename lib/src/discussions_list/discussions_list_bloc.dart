import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';

import 'discussions_list.dart';

class DiscussionsListBloc
    extends Bloc<DiscussionsListEvent, DiscussionsListState> {
  DiscussionsListBloc(this.chatService, this.groupManagementBloc, this.userId)
      : assert(chatService != null),
        assert(groupManagementBloc != null),
        assert(userId != null) {
    _subDiscussions =
        chatService.streamOfUserDiscussions(userId).listen((discussions) {
      dispatch(SyncDiscussionsList(discussions));
    });
  }
  ChatService chatService;
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
