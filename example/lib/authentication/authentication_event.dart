import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable{
AuthenticationEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class LogIn extends AuthenticationEvent {
  @override
  String toString() => 'LogIn';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}
