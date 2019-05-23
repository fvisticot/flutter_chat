import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/discussions_list/discussions_list_ui.dart';
import 'package:flutter_chat/src/group_chat/group_chat_ui.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';
import 'package:flutter_chat/src/search_user/search_user_ui.dart';

class ChatHomePage extends StatefulWidget {
  final FirebaseRepository firebaseRepository;
  final User currentUser;

  ChatHomePage(this.firebaseRepository, this.currentUser)
      : assert(firebaseRepository != null),
        assert(currentUser != null);

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
    stateStream = groupManagementBloc.state.listen((state) {
      if (state is NavigateToGroupState) {
        _navigateToChatPage(state.groupId);
      }
    });
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    stateStream.cancel();
    groupManagementBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupManagementEvent, GroupManagementState>(
        bloc: groupManagementBloc,
        builder: (context, state) {
          if (state is CreatingGroupState) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
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
                  title: Text('Chat'),
                  centerTitle: true,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(149, 152, 178, 1),
                          Color.fromRGBO(90, 95, 129, 1)
                        ],
                      ),
                    ),
                  ),
                  bottom: TabBar(
                      controller: _tabController,
                      isScrollable: false,
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(icon: Icon(Icons.chat)),
                        Tab(icon: Icon(Icons.search)),
                      ])),
              body: TabBarView(controller: _tabController, children: <Widget>[
                DiscussionsListPage(widget.firebaseRepository,
                    groupManagementBloc, widget.currentUser),
                SearchUserPage(widget.firebaseRepository, widget.currentUser,
                    groupManagementBloc),
              ]),
            );
          }
        });
  }

  _navigateToChatPage(groupId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GroupChatPage(
            groupId, widget.currentUser, widget.firebaseRepository)));
  }
}
