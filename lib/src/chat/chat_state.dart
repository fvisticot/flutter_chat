import 'package:equatable/equatable.dart';
import 'package:flutter_chat/src/models/user.dart';

abstract class ChatState extends Equatable {
  ChatState([List props = const []]) : super(props);
}

class ChatUninitialized extends ChatState {
  @override
  String toString() => 'ChatUninitialized';
}

class ChatInitialized extends ChatState {
  User user;

  ChatInitialized(this.user)
      :assert(user!= null),
        super([user]);

  @override
  String toString() => 'ChatInitialized $user';
}

class ChatLoading extends ChatState {
  @override
  String toString() => 'ChatLoading';
}