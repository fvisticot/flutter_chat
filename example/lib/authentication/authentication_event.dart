import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AppStarted extends AuthenticationEvent {
  @override
  List<Object> get props => [];
  @override
  String toString() => 'AppStarted';
}

class LogIn extends AuthenticationEvent {
  @override
  List<Object> get props => [];
  @override
  String toString() => 'LogIn';
}

class LoggedOut extends AuthenticationEvent {
  @override
  List<Object> get props => [];
  @override
  String toString() => 'LoggedOut';
}
