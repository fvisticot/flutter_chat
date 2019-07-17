import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/flutter_chat.dart';
import 'package:flutter_chat_example/prechat.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'authentication/authentication.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
    super.onError(error, stacktrace);
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(ChatDemoApp());
}

class ChatDemoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatDemoAppState();
}

class _ChatDemoAppState extends State<ChatDemoApp> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseApp app = FirebaseApp.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  AuthenticationBloc _authenticationBloc;
  FirebaseDatabase database;
  FirebaseChatService chatService;

  @override
  void initState() {
    database = FirebaseDatabase(app: app);
    chatService = FirebaseChatService(database);
    _authenticationBloc = AuthenticationBloc(
      googleSignIn,
      firebaseAuth,
      chatService,
    );
    _authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: MaterialApp(
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationAuthenticated) {
              chatService.setDevicePushToken();
              chatService.initPresence();
              return PreChat(
                chatService: chatService,
              );
            } else if (state is AuthenticationUnauthenticated) {
              return AuthenticationPage();
            } else {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator()),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
