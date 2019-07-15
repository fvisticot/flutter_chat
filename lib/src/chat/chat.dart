import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/chat/chat_bloc.dart';
import 'package:flutter_chat/src/chat/chat_event.dart';
import 'package:flutter_chat/src/chat/chat_state.dart';
import 'package:flutter_chat/src/chat_home/chat_home_page.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/chat_service/firebase_chat_service.dart';
import 'package:flutter_chat/src/group_chat/group_chat.dart';

class Chat extends StatefulWidget {
  const Chat(this.userName, {this.groupId}) : assert(userName != null);
  final String userName;
  final String groupId;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with WidgetsBindingObserver {
  ChatBloc _chatBloc;
  ChatService chatService;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    chatService = FirebaseChatService(FirebaseDatabase.instance);
    _chatBloc = ChatBloc(chatService);
    _chatBloc.dispatch(ChatStarted(widget.userName));
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      chatService.setPresence(presence: true);
    } else {
      chatService.setPresence(presence: false);
    }
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
            return GroupChatPage(widget.groupId, state.user, chatService);
          } else {
            return ChatHomePage(chatService, state.user);
          }
        } else {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: const SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
