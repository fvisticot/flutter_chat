import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';
import 'user_presence.dart';

class UserPresenceIndicator extends StatefulWidget {
  final FirebaseRepository firebaseRepository;
  final String userId;

  UserPresenceIndicator(this.firebaseRepository, this.userId)
      : assert(firebaseRepository != null),
        assert(userId != null);
  @override
  _UserPresenceIndicatorState createState() => _UserPresenceIndicatorState();
}

class _UserPresenceIndicatorState extends State<UserPresenceIndicator> {
  UserPresenceBloc _userPresenceBloc;

  @override
  void initState() {
    super.initState();
    _userPresenceBloc =
        UserPresenceBloc(widget.firebaseRepository, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPresenceEvent, UserPresenceState>(
        bloc: _userPresenceBloc,
        builder: (context, userPresenceState) {
          if (userPresenceState is UserPresenceIsOnline) {
            return Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                color: (userPresenceState.isOnline) ? Colors.green : Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
            );
          } else if (userPresenceState is UserPresenceLoading) {
            return Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
