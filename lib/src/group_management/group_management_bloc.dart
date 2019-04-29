import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';

class GroupManagementBloc
    extends Bloc<GroupManagementEvent, GroupManagementState> {
  FirebaseRepository firebaseRepository;

  GroupManagementBloc(this.firebaseRepository)
      : assert(firebaseRepository != null);

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
      String groupId =
          await firebaseRepository.createDuoGroup(event.currentUid, event.uid);
      yield NavigateToGroupState(groupId);
    }
  }
}
