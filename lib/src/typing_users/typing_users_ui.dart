import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'typing_users.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';

class TypingUsers extends StatefulWidget {
  final FirebaseRepository firebaseRepository;
  final String groupId;
  final User currentUser;

  TypingUsers(this.firebaseRepository, this.groupId, this.currentUser)
      : assert(firebaseRepository != null),
        assert(groupId!= null),
        assert(currentUser!= null);

  @override
  _TypingUsersState createState() => _TypingUsersState();
}

class _TypingUsersState extends State<TypingUsers> {
  TypingUsersBloc _typingUsersBloc;

  @override
  void initState() {
    _typingUsersBloc = TypingUsersBloc(widget.firebaseRepository, widget.groupId, widget.currentUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TypingUsersEvent, TypingUsersState>(
        bloc: _typingUsersBloc,
        builder: (context, typingUsersState) {
          if (typingUsersState is TypingUsersList) {
            if (typingUsersState.usersNames.length == 0){
              return Container();
            } else {
              String typingMsg;
              if (typingUsersState.usersNames.length > 1){
                typingMsg = 'Users are typing ...';
              } else {
                typingMsg = '${typingUsersState.usersNames.first} is typing ...';
              }
              return Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Text(typingMsg, style: TextStyle(color: Colors.grey),)
                  )
                ],
              );
            }
          } else {
            return Container();
          }
        }
    );
  }
}

