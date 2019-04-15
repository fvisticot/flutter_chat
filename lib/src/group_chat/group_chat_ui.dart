import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/message_bar/message_bar_ui.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';
import 'package:flutter_chat/src/models/models.dart';
import 'package:flutter_chat/src/group_messages/group_messages.dart';
import 'package:flutter_chat/src/typing_users/typing_users_ui.dart';
import 'package:flutter_chat/src/upload_file/upload_file.dart';
import 'package:intl/intl.dart';
import 'group_chat.dart';
import 'package:flutter_chat/src/user_presence/user_presence_ui.dart';

class GroupChatPage extends StatefulWidget {
  final String groupId;
  final User currentUser;
  final FirebaseRepository firebaseRepository;

  GroupChatPage(this.groupId, this.currentUser, this.firebaseRepository);

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
    _groupChatBloc = GroupChatBloc(widget.firebaseRepository, widget.groupId);
    _groupChatBloc.dispatch(GroupChatStarted(widget.groupId));
    _groupMessagesBloc =
        GroupMessagesBloc(widget.firebaseRepository, widget.groupId);
    _uploadFileBloc = UploadFileBloc();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupChatEvent, GroupChatState>(
        bloc: _groupChatBloc,
        builder: (context, groupChatState) {
          if (groupChatState is GroupChatInitial) {
            return Scaffold(
              body: Container(),
            );
          } else if (groupChatState is GroupChatSuccess) {
            if (groupChatState.group.users.length > 2) {
              return Scaffold(
                appBar: AppBar(
                    title: Text(
                  groupChatState.group.title,
                  maxLines: 1,
                )),
                body: Column(
                  //alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    TypingUsers(widget.firebaseRepository, widget.groupId,
                        widget.currentUser),
                    MessageBar(widget.firebaseRepository, widget.groupId,
                        widget.currentUser, _uploadFileBloc),
                  ],
                ),
              );
            } else {
              String title =
                  (groupChatState.group.users[1].id == widget.currentUser.id)
                      ? groupChatState.group.users[0].userName
                      : groupChatState.group.users[1].userName;
              return Scaffold(
                appBar: AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.brown.shade800,
                          child: Text('AH'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child:
                          UserPresenceIndicator(
                              widget.firebaseRepository,
                              (groupChatState.group.users[1].id == widget.currentUser.id)
                              ? groupChatState.group.users[0].id
                              : groupChatState.group.users[1].id
                          ),
                        )
                      ]),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        title,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  bottom: PreferredSize(
                      child: BlocBuilder<UploadFileEvent, UploadFileState>(
                          bloc: _uploadFileBloc,
                          builder: (context, uploadFileState) {
                            if (uploadFileState is UploadFileInitial) {
                              return Container();
                            } else if (uploadFileState is UploadFileProgress) {
                              return LinearProgressIndicator(
                                value: uploadFileState.progress,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.green),
                              );
                            }
                          }),
                      preferredSize: const Size(double.infinity, 6)),
                ),
                body: Column(
                  //alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Expanded(
                      child: _buildMessagesList(),
                    ),
                    TypingUsers(widget.firebaseRepository, widget.groupId,
                        widget.currentUser),
                    MessageBar(widget.firebaseRepository, widget.groupId,
                        widget.currentUser, _uploadFileBloc),
                  ],
                ),
              );
            }
          } else if (groupChatState is GroupChatLoading) {
            return Scaffold(
              body: Container(),
            );
          }
        });
  }

  _buildMessagesList() {
    return Container(
      child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scrollbar(
              child: BlocBuilder<GroupMessagesEvent, GroupMessagesState>(
                  bloc: _groupMessagesBloc,
                  builder: (context, groupMessagesState) {
                    if (groupMessagesState is GroupMessagesInitial) {
                      return Container();
                    } else if (groupMessagesState is GroupMessagesSuccess) {
                      List<Message> messages = groupMessagesState.messages;
                      if (messages.length == 0) {
                        return Container();
                      } else {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(0,
                              duration: Duration(milliseconds: 50),
                              curve: Curves.easeIn);
                        }
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          controller: _scrollController,
                          reverse: true,
                          scrollDirection: Axis.vertical,
                          itemCount: messages.length,
                          itemBuilder: (BuildContext context, int i) {
                            return _buildMessage(messages[i]);
                          },
                        );
                      }
                    }
                  }))),
    );
  }

  Widget _buildMessage(Message message) {
    bool isMine = widget.currentUser.id == message.userId ? true : false;
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
        child: Row(
          mainAxisAlignment:
              isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: isMine
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        DateFormat('dd/MM/yyyy - kk:mm:ss')
                            .format(message.timestamp),
                        style: TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                    ),
                    message.displayMessage(isMine),
                    //Container(
                    //child: Text(message.timestamp.toIso8601String()),
                    //)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
