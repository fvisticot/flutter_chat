import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/chat_service/firebase_chat_service.dart';
import 'package:flutter_chat/src/common/styles.dart';
import 'package:flutter_chat/src/group_chat/group_chat_ui.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/models/user.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage(this.firebaseRepository, this.currentUser)
      : assert(firebaseRepository != null),
        assert(currentUser != null);
  final FirebaseChatService firebaseRepository;
  final User currentUser;

  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage>
    with SingleTickerProviderStateMixin {
  GroupManagementBloc groupManagementBloc;
  StreamSubscription stateStream;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    groupManagementBloc = GroupManagementBloc(widget.firebaseRepository);

    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    stateStream.cancel();
    groupManagementBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: groupManagementBloc,
      listener: (context, state) {
        if (state is NavigateToGroupState) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GroupChatPage(
                state.groupId,
                widget.currentUser,
                widget.firebaseRepository,
              ),
            ),
          );
        }
      },
      child: BlocBuilder<GroupManagementBloc, GroupManagementState>(
          bloc: groupManagementBloc,
          builder: (context, state) {
            if (state is CreatingGroupState) {
              return Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Styles.mainColor),
                    ),
                    SizedBox(
                      height: 20,
                      width: 20,
                    ),
                    Text('Creating discussion')
                  ],
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Chat'),
                  centerTitle: true,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(gradient: Styles.gradient),
                  ),
                  bottom: TabBar(
                    controller: _tabController,
                    isScrollable: false,
                    indicatorColor: Colors.white,
                    tabs: const [
                      Tab(
                        text: 'Discussions',
                      ),
                      Tab(text: 'Contacts'),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
