import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/typing_users/typing_users.dart';

class TypingUsers extends StatefulWidget {
  const TypingUsers(
    this.chatService,
    this.groupId,
    this.currentUser,
  )   : assert(chatService != null),
        assert(groupId != null),
        assert(currentUser != null);
  final ChatService chatService;
  final String groupId;
  final User currentUser;

  @override
  _TypingUsersState createState() => _TypingUsersState();
}

class _TypingUsersState extends State<TypingUsers> {
  TypingUsersBloc _typingUsersBloc;

  @override
  void initState() {
    _typingUsersBloc = TypingUsersBloc(widget.chatService, widget.groupId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TypingUsersBloc, TypingUsersState>(
        cubit: _typingUsersBloc,
        builder: (context, typingUsersState) {
          if (typingUsersState is TypingUsersList) {
            if (typingUsersState.usersNames.isEmpty) {
              return Container();
            } else {
              String typingMsg;
              if (typingUsersState.usersNames.length > 1) {
                typingMsg = 'Des utilisateurs écrivents...';
              } else {
                typingMsg =
                    '${typingUsersState.usersNames.first} est en train d\'écrire...';
              }
              return Row(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Text(
                        typingMsg,
                        style: TextStyle(color: Colors.grey),
                      ))
                ],
              );
            }
          } else {
            return Container();
          }
        });
  }
}
