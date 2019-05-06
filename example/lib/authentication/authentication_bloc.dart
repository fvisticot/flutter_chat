import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'authentication.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;

  AuthenticationBloc(this.googleSignIn, this.firebaseAuth)
      : assert(googleSignIn != null),
        assert(firebaseAuth != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      bool googleIsSignedIn = await googleSignIn.isSignedIn();
      if (googleIsSignedIn) {
        FirebaseUser fbUser = await firebaseAuth.currentUser();
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
        final FirebaseUser user =
            await firebaseAuth.signInWithCredential(credential);
        final FirebaseUser currentUser = await firebaseAuth.currentUser();
        assert(user.uid == currentUser.uid);
        yield AuthenticationAuthenticated();
      } catch (e) {
        print(e);
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await firebaseAuth.signOut();
      yield AuthenticationUnauthenticated();
    }
  }
}
