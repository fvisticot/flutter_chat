import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/models/group.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';
import 'group_chat.dart';

class GroupChatBloc extends Bloc<GroupChatEvent, GroupChatState> {
  FirebaseRepository firebaseRepository;
  String groupId;

  GroupChatBloc(this.firebaseRepository, this.groupId)
      : assert (firebaseRepository != null),
        assert (groupId!= null);

  @override
  GroupChatState get initialState => GroupChatInitial();

  @override
  Stream<GroupChatState> mapEventToState(
      GroupChatEvent event) async* {
    if (event is GroupChatStarted) {
      yield GroupChatLoading();
      Group group = await firebaseRepository.getGroupInfo(event.groupId);
      yield GroupChatSuccess(group);
    }
  }

}
