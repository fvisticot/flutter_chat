import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/discussions_list/discussions_list_ui.dart';
import 'package:flutter_chat/src/group_chat/group_chat_ui.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';
import 'package:flutter_chat/src/search_user/search_user.dart';
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
  SearchUserBloc searchUserBloc;
  StreamSubscription stateStream;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    searchUserBloc = SearchUserBloc(widget.firebaseRepository);
    stateStream = searchUserBloc.state.listen((state) {
      if (state is SearchUserGroupChat) {
        _navigateToChatPage(state.groupId);
      }
    });
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    stateStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Chat'),
          bottom: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorColor: Colors.white,
              tabs: [Tab(text: 'My discussions'), Tab(text: 'Search User')])),
      body: TabBarView(controller: _tabController, children: <Widget>[
        DiscussionsListPage(),
        BlocProvider(
          bloc: searchUserBloc,
          child: SearchUserPage(widget.currentUser),
        )
      ]),
    );
  }

  _navigateToChatPage(groupId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GroupChatPage(
            groupId, widget.currentUser, widget.firebaseRepository)));
  }
}
