import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationUninitialized extends AuthenticationState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AuthenticationUninitialized';
}

class AuthenticationAuthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
  @override
  String toString() => 'AuthenticationAuthenticated';
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
  @override
  String toString() => 'AuthenticationUnauthenticated';
}

class AuthenticationLoading extends AuthenticationState {
  @override
  List<Object> get props => [];
  @override
  String toString() => 'AuthenticationLoading';
}
