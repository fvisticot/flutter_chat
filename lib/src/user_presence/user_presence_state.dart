import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class UserPresenceState extends Equatable {
  UserPresenceState([List props = const []]) : super(props);
}

class UserPresenceIsOnline extends UserPresenceState {
  UserPresenceIsOnline({@required this.isOnline})
      : assert(isOnline != null),
        super([isOnline]);
  final bool isOnline;

  @override
  String toString() => 'UserPresenceIsOnline $isOnline';
}

class UserPresenceLoading extends UserPresenceState {
  @override
  String toString() => 'UserPresenceLoading';
}
