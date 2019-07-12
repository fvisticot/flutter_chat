import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/models/group.dart';
import 'package:flutter_chat/src/repositories/chat_firebase_repository.dart';
import 'group_chat.dart';

class GroupChatBloc extends Bloc<GroupChatEvent, GroupChatState> {
  GroupChatBloc(
    this.firebaseRepository,
    this.groupId,
  )   : assert(firebaseRepository != null),
        assert(groupId != null);
  ChatFirebaseRepository firebaseRepository;
  String groupId;

  @override
  GroupChatState get initialState => GroupChatInitial();

  @override
  Stream<GroupChatState> mapEventToState(GroupChatEvent event) async* {
    if (event is GroupChatStarted) {
      yield GroupChatLoading();
      final Group group = await firebaseRepository.getGroupInfo(event.groupId);
      yield GroupChatSuccess(group);
    }
  }
}
