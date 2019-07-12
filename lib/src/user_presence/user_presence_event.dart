import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class UserPresenceEvent extends Equatable {
  UserPresenceEvent({@required this.isOnline})
      : assert(isOnline != null),
        super([isOnline]);
  final bool isOnline;

  @override
  String toString() => 'UserPresenceEvent $isOnline';
}
