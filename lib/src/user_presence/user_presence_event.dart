import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class UserPresenceEvent extends Equatable {
  const UserPresenceEvent({@required this.isOnline}) : assert(isOnline != null);
  final bool isOnline;

  @override
  List<Object> get props => [isOnline];
  @override
  String toString() => 'UserPresenceEvent $isOnline';
}
