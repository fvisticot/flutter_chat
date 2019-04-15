import 'package:equatable/equatable.dart';

class UserPresenceEvent extends Equatable {
  final bool isOnline;

  UserPresenceEvent(this.isOnline)
      :assert (isOnline!=null),
        super([isOnline]);

  @override
  String toString() => 'UserPresenceEvent $isOnline';
}