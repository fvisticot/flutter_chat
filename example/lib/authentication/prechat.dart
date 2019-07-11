import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';
import 'package:firebase_database/firebase_database.dart';

class PreChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You should appear as connected to the chat'),
            RaisedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      Chat(FirebaseDatabase.instance, 'testName'),
                ),
              ),
              child: Text('Open Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
