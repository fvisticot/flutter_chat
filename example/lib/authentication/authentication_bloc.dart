import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bloc/bloc.dart';
import 'authentication.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this.googleSignIn, this.firebaseAuth)
      : assert(googleSignIn != null),
        assert(firebaseAuth != null);
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

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
        if (user.uid != currentUser.uid) {
          throw Exception();
        }
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
