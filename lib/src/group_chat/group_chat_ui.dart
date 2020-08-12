import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/common/styles.dart';
import 'package:flutter_chat/src/group_messages/group_messages.dart';
import 'package:flutter_chat/src/message_bar/message_bar_ui.dart';
import 'package:flutter_chat/src/models/group.dart';
import 'package:flutter_chat/src/models/message/message.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/typing_users/typing_users_ui.dart';
import 'package:flutter_chat/src/upload_file/upload_file.dart';
import 'package:flutter_chat/src/user_presence/user_presence_ui.dart';
import 'package:intl/intl.dart';

import 'group_chat.dart';

class GroupChatPage extends StatefulWidget {
  const GroupChatPage(this.groupId, this.currentUser, this.chatService);
  final String groupId;
  final User currentUser;
  final ChatService chatService;

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  GroupChatBloc _groupChatBloc;
  GroupMessagesBloc _groupMessagesBloc;
  ScrollController _scrollController;
  UploadFileBloc _uploadFileBloc;

  @override
  void initState() {
    super.initState();
    _groupChatBloc = GroupChatBloc(widget.chatService, widget.groupId);
    _groupChatBloc.add(GroupChatStarted(widget.groupId));
    _groupMessagesBloc = GroupMessagesBloc(widget.chatService, widget.groupId);
    _uploadFileBloc = UploadFileBloc();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupChatBloc, GroupChatState>(
        cubit: _groupChatBloc,
        builder: (context, groupChatState) {
          if (groupChatState is GroupChatInitial) {
            return Scaffold(
              body: Container(),
            );
          } else if (groupChatState is GroupChatSuccess) {
            return Scaffold(
              appBar: _buildAppBar(groupChatState.group),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: _buildMessagesList(groupChatState.group),
                  ),
                  TypingUsers(
                      widget.chatService, widget.groupId, widget.currentUser),
                  SafeArea(
                    bottom: true,
                    child: MessageBar(widget.chatService, widget.groupId,
                        widget.currentUser, _uploadFileBloc),
                  ),
                ],
              ),
            );
          } else if (groupChatState is GroupChatError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Chat'),
                flexibleSpace: Container(
                  decoration: BoxDecoration(gradient: Styles.gradient),
                ),
              ),
              body: Center(
                child: const Text('Erreur lors du chargement de la discussion'),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Styles.mainColor),
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget _buildAppBar(Group group) {
    if (group.users.length > 2) {
      return AppBar(
        title: Text(
          group.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Styles.gradient,
          ),
        ),
      );
    } else {
      final String userId = group.users.keys
          .firstWhere((k) => k != widget.currentUser.id, orElse: () => null);
      final String title = group.users[userId];
      return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.brown.shade800,
                child: Text(title.substring(0, 1).toUpperCase()),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: UserPresenceIndicator(widget.chatService, userId),
              )
            ]),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: Styles.gradient),
        ),
        bottom: PreferredSize(
            child: BlocBuilder<UploadFileBloc, UploadFileState>(
                cubit: _uploadFileBloc,
                builder: (context, uploadFileState) {
                  if (uploadFileState is UploadFileProgress) {
                    return LinearProgressIndicator(
                      value: uploadFileState.progress,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    );
                  } else {
                    return Container();
                  }
                }),
            preferredSize: const Size(double.infinity, 6)),
      );
    }
  }

  Widget _buildMessagesList(Group group) {
    return Container(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scrollbar(
          child: BlocBuilder<GroupMessagesBloc, GroupMessagesState>(
            cubit: _groupMessagesBloc,
            builder: (context, groupMessagesState) {
              if (groupMessagesState is GroupMessagesInitial) {
                return Container();
              } else if (groupMessagesState is GroupMessagesSuccess) {
                final List<Message> messages = groupMessagesState.messages;
                if (messages.isEmpty) {
                  return Container();
                } else {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(0,
                        duration: Duration(milliseconds: 50),
                        curve: Curves.easeIn);
                  }
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollController,
                    reverse: true,
                    scrollDirection: Axis.vertical,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int i) {
                      return _buildMessage(messages[i], group);
                    },
                  );
                }
              } else {
                return Center(
                  child: const Text('Error loading Messages'),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(Message message, Group group) {
    final bool isDuo = (group.users.length > 2) ? false : true;
    final bool isMine =
        (widget.currentUser.id == message.userId) ? true : false;

    return Row(
      mainAxisAlignment:
          isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                (isDuo || isMine)
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          group.users[message.userId],
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                message.displayMessage(context, isMine: isMine),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    DateFormat('dd/MM/yyyy - kk:mm:ss')
                        .format(message.timestamp),
                    style: TextStyle(fontSize: 9, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
