import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/chat/chat_bloc.dart';
import 'package:flutter_chat/src/chat/chat_event.dart';
import 'package:flutter_chat/src/chat/chat_state.dart';
import 'package:flutter_chat/src/chat_home/chat_home_page.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/group_chat/group_chat.dart';

class Chat extends StatefulWidget {
  const Chat(this.chatService, {this.groupId}) : assert(chatService != null);
  final ChatService chatService;
  final String groupId;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with WidgetsBindingObserver {
  ChatBloc _chatBloc;

  @override
  void initState() {
    _chatBloc = ChatBloc(widget.chatService);
    _chatBloc.dispatch(ChatStarted());
    super.initState();
  }

  @override
  void dispose() {
    _chatBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: _chatBloc,
      builder: (BuildContext context, ChatState state) {
        if (state is ChatError) {
          return Scaffold(
            body: Center(
              child: const Text('Error loading chat'),
            ),
          );
        }
        if (state is ChatInitialized) {
          if (widget.groupId != null) {
            return GroupChatPage(
              widget.groupId,
              state.user,
              widget.chatService,
            );
          } else {
            return ChatHomePage(widget.chatService, state.user);
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
}
