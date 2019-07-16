import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';
import 'package:flutter_chat_example/authentication/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_example/authentication/authentication_event.dart';

class PreChat extends StatelessWidget {
  const PreChat({Key key, @required this.chatService})
      : assert(chatService != null),
        super(key: key);
  final FirebaseChatService chatService;

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc _authBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return ChatPresenceWidget(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You should appear as connected to the chat'),
              RaisedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Chat(chatService),
                  ),
                ),
                child: const Text('Open Chat'),
              ),
              const SizedBox(
                height: 50,
              ),
              RaisedButton(
                onPressed: () => _authBloc.dispatch(LoggedOut()),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
      chatService: chatService,
    );
  }
}
