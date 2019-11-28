import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class UserPresenceState extends Equatable {
  const UserPresenceState();
}

class UserPresenceIsOnline extends UserPresenceState {
  const UserPresenceIsOnline({@required this.isOnline})
      : assert(isOnline != null);
  final bool isOnline;

  @override
  String toString() => 'UserPresenceIsOnline $isOnline';

  @override
  List<Object> get props => [isOnline];
}

class UserPresenceLoading extends UserPresenceState {
  @override
  String toString() => 'UserPresenceLoading';

  @override
  List<Object> get props => [];
}
