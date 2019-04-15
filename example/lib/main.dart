import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';
import 'authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
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

  @override
  void initState() {
    database = FirebaseDatabase(app: app);
    database.setPersistenceEnabled(false);

    _authenticationBloc = AuthenticationBloc(googleSignIn, firebaseAuth);
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
            if (state is AuthenticationUninitialized) {
              // TODO : SPLASHSCREEN
              return Container(decoration: BoxDecoration(color: Colors.lightGreen),);
            }
            if (state is AuthenticationAuthenticated) {
              return Chat(database, 'Toto', groupId:'MzuQUqGjXVXnu3urV9SmrWJXMeW2_vxri76DaHNQ709FIlFptYxugwN93');
            }
            if (state is AuthenticationUnauthenticated) {
              return AuthenticationPage();
            }
            if (state is AuthenticationLoading) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                /*child: Center(
                  child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator()),
                ),*/
              );
            }
          },
        ),
      ),
    );
  }
}
