import 'package:flutter/material.dart';
import 'package:flutter_chat/src/common/styles.dart';
import 'package:flutter_chat/src/models/message/message.dart';

class TextMessage extends Message {
  final String text;

  TextMessage(this.text, String userId, {DateTime timestamp})
      : super(userId, timestamp: timestamp) {
    type = MessageType.text;
  }

  factory TextMessage.fromMap(Map map) {
    return TextMessage(
      map['text'],
      map['userId'],
      timestamp:
          DateTime.fromMillisecondsSinceEpoch(map['timestamp'], isUtc: true)
              .toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'type': 'text',
        'text': text,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  Widget displayMessage(isMine, context) {
    return Container(
        child: Text(
          '$text',
          softWrap: true,
          style: isMine ? Styles.myMessagetext : Styles.otherMessagetext,
        ),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isMine ? Styles.mainColor : Styles.otherMessageBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ));
  }

  @override
  String toString() {
    return 'TextMessage{type: $type, userId: $userId timestamp: $timestamp, text: $text}';
  }
}
