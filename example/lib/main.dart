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

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stacktrace) {
    super.onError(cubit, error, stacktrace);
    print('$error, $stacktrace');
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();
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
  FirebaseDatabase database;
  FirebaseChatService chatService;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (_) {
        database = FirebaseDatabase(app: app);
        chatService = FirebaseChatService(database);
        final AuthenticationBloc _authenticationBloc = AuthenticationBloc(
          googleSignIn,
          firebaseAuth,
          chatService,
        );
        _authenticationBloc.add(AppStarted());
        return _authenticationBloc;
      },
      child: MaterialApp(
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationAuthenticated) {
              chatService.setDevicePushToken();
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
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
