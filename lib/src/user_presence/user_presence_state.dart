import 'package:equatable/equatable.dart';

class UserPresenceState extends Equatable {
  UserPresenceState([List props = const []]) : super(props);
}

class UserPresenceIsOnline extends UserPresenceState {
  final bool isOnline;

  UserPresenceIsOnline(this.isOnline)
      : assert(isOnline!=null),
        super([isOnline]);

  @override
  String toString() => 'UserPresenceIsOnline $isOnline';
}

class UserPresenceLoading extends UserPresenceState {

  @override
  String toString() => 'UserPresenceLoading ';
}