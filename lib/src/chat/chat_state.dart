import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/user.dart';

abstract class ChatState extends Equatable {
  const ChatState();
}

class ChatUninitialized extends ChatState {
  @override
  String toString() => 'ChatUninitialized';
  @override
  List<Object> get props => [];
}

class ChatInitialized extends ChatState {
  const ChatInitialized(this.user) : assert(user != null);
  final User user;

  @override
  String toString() => 'ChatInitialized $user';

  @override
  List<Object> get props => [user];
}

class ChatLoading extends ChatState {
  @override
  String toString() => 'ChatLoading';
  @override
  List<Object> get props => [];
}

class ChatError extends ChatState {
  @override
  String toString() => 'ChatError';
  @override
  List<Object> get props => [];
}
