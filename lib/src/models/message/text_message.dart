import 'package:flutter/material.dart';
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

  Widget displayMessage(isMine) {
    return Container(
      child: Text(
        '$text',
        softWrap: true,
      ),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: isMine ? Colors.blue : Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.grey.withOpacity(0.3))),
    );
  }

  @override
  String toString() {
    return 'TextMessage{type: $type, userId: $userId timestamp: $timestamp, text: $text}';
  }
}
