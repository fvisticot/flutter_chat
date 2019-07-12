import 'package:flutter/material.dart';
import 'package:flutter_chat/src/models/message/photo_message.dart';
import 'package:flutter_chat/src/models/message/text_message.dart';

enum MessageType { text, audio, photo, video, file, sticker, unknown }

abstract class Message {
  Message(this.userId, {this.timestamp}) {
    timestamp ??= DateTime.now();
  }
  DateTime timestamp;
  MessageType type;
  String userId;

  Map<String, dynamic> toJson();
  Widget displayMessage(BuildContext context, {@required bool isMine});
  static dynamic fromMap(Map map) {
    switch (map['type']) {
      case 'text':
        return TextMessage.fromMap(map);
      case 'photo':
        return PhotoMessage.fromMap(map);
    }
  }
}
