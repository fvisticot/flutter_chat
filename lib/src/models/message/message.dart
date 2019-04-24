import 'package:flutter/material.dart';
import 'package:flutter_chat/src/models/message/photo_message.dart';
import 'package:flutter_chat/src/models/message/text_message.dart';

enum MessageType { text, audio, photo, video, file, sticker, unknown }

abstract class Message {
  DateTime timestamp;
  MessageType type;
  String userId;

  Message(this.userId, {this.timestamp}) {
    if (this.timestamp == null) {
      this.timestamp = DateTime.now();
    }
  }

  Map<String, dynamic> toJson();
  Widget displayMessage(bool isMine);

  static dynamic fromMap(Map map) {
    switch (map['type']) {
      case 'text':
        return TextMessage.fromMap(map);
      case 'photo':
        return PhotoMessage.fromMap(map);
    }
  }
}
