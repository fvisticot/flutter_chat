import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/repositories/chat_firebase_repository.dart';

class GroupManagementBloc
    extends Bloc<GroupManagementEvent, GroupManagementState> {
  GroupManagementBloc(this.firebaseRepository)
      : assert(firebaseRepository != null);
  ChatFirebaseRepository firebaseRepository;

  @override
  GroupManagementState get initialState => GroupManagementInitialState();

  @override
  Stream<GroupManagementState> mapEventToState(
      GroupManagementEvent event) async* {
    if (event is NavigateToGroup) {
      yield NavigateToGroupState(event.groupId);
      yield GroupManagementInitialState();
    }
    if (event is CreateDuoGroup) {
      yield CreatingGroupState();
      final String groupId =
          await firebaseRepository.createDuoGroup(event.currentUid, event.uid);
      yield NavigateToGroupState(groupId);
    }
  }
}
