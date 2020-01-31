import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/discussions_list/discussions_list.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';

class DiscussionsListBloc
    extends Bloc<DiscussionsListEvent, DiscussionsListState> {
  DiscussionsListBloc(
    this.chatService,
    this.groupManagementBloc,
    this.userId,
  )   : assert(chatService != null),
        assert(groupManagementBloc != null),
        assert(userId != null) {
    chatService.streamOfUserDiscussions().then(
      (discussionsStream) {
        _subDiscussions = discussionsStream.listen(
          (discussions) {
            add(SyncDiscussionsList(discussions));
          },
        );
      },
      onError: (e) {
        add(ErrorSyncDiscussionsList());
      },
    );
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
  Future<void> close() async {
    _subDiscussions?.cancel();
    super.close();
  }
}
