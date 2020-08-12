import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_chat/flutter_chat.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'authentication.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
    this.googleSignIn,
    this.firebaseAuth,
    this.chatService,
  )   : assert(googleSignIn != null),
        assert(firebaseAuth != null),
        assert(chatService != null),
        super(AuthenticationUninitialized());
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseChatService chatService;

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final bool googleIsSignedIn = await googleSignIn.isSignedIn();
      if (googleIsSignedIn) {
        final FirebaseUser fbUser = await firebaseAuth.currentUser();
        if (fbUser != null) {
          yield AuthenticationAuthenticated();
        } else {
          yield AuthenticationUnauthenticated();
        }
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LogIn) {
      yield AuthenticationLoading();
      final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
        },
        onResume: (Map<String, dynamic> message) async {
          print('on resume $message');
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('on launch $message');
        },
      );
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });

      String token = await _firebaseMessaging.getToken();
      print("Push Messaging token: $token");

      try {
        final GoogleSignInAccount googleUser = await googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final AuthResult authRes =
            await firebaseAuth.signInWithCredential(credential);
        final FirebaseUser user = authRes.user;
        final FirebaseUser currentUser = await firebaseAuth.currentUser();
        if (user.uid != currentUser.uid) {
          throw Exception();
        }
        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
        _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) {
            print('onMessage received: $message');
            return;
          },
          onLaunch: (Map<String, dynamic> message) {
            print('onLaunch: $message');
            return;
          },
          onResume: (Map<String, dynamic> message) {
            print('onResume: $message');
            return;
          },
        );
        _firebaseMessaging.requestNotificationPermissions(
            const IosNotificationSettings(
                sound: true, badge: true, alert: true));
        _firebaseMessaging.onIosSettingsRegistered
            .listen((IosNotificationSettings settings) {
          print('Settings registered: $settings');
        });
        yield AuthenticationAuthenticated();
      } catch (e) {
        print(e);
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await chatService.setPresence(presence: false);
      await firebaseAuth.signOut();
      yield AuthenticationUnauthenticated();
    }
  }
}
