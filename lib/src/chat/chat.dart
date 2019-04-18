import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/chat/chat_bloc.dart';
import 'package:flutter_chat/src/chat/chat_event.dart';
import 'package:flutter_chat/src/chat/chat_state.dart';
import 'package:flutter_chat/src/chat_home/chat_home_page.dart';
import 'package:flutter_chat/src/group_chat/group_chat.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';

class Chat extends StatefulWidget {
  final FirebaseDatabase firebaseDatabase;
  final String userName;
  final String groupId;

  Chat(this.firebaseDatabase, this.userName, {this.groupId})
      : assert(firebaseDatabase != null),
        assert(userName != null);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ChatBloc _chatBloc;
  FirebaseRepository firebaseRepository;

  @override
  void initState() {
    firebaseRepository = FirebaseRepository(widget.firebaseDatabase);
    _chatBloc = ChatBloc(firebaseRepository);
    _chatBloc.dispatch(ChatStarted(widget.userName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatEvent, ChatState>(
      bloc: _chatBloc,
      builder: (BuildContext context, ChatState state) {
        if (state is ChatUninitialized) {
          return Container(
            decoration: BoxDecoration(color: Colors.white),
          );
        }
        if (state is ChatInitialized) {
          if (widget.groupId != null) {
            return GroupChatPage(
                widget.groupId, state.user, firebaseRepository);
          } else {
            return ChatHomePage(firebaseRepository, state.user);
          }
        }
        if (state is ChatLoading) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
