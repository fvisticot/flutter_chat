import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/repositories/chat_firebase_repository.dart';

import 'typing_users.dart';

class TypingUsers extends StatefulWidget {
  const TypingUsers(
    this.firebaseRepository,
    this.groupId,
    this.currentUser,
  )   : assert(firebaseRepository != null),
        assert(groupId != null),
        assert(currentUser != null);
  final ChatFirebaseRepository firebaseRepository;
  final String groupId;
  final User currentUser;

  @override
  _TypingUsersState createState() => _TypingUsersState();
}

class _TypingUsersState extends State<TypingUsers> {
  TypingUsersBloc _typingUsersBloc;

  @override
  void initState() {
    _typingUsersBloc = TypingUsersBloc(
        widget.firebaseRepository, widget.groupId, widget.currentUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TypingUsersEvent, TypingUsersState>(
        bloc: _typingUsersBloc,
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
