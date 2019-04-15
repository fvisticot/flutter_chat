import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum MessageType { text, audio, photo, video, file, sticker, unknown }

abstract class Message {
  DateTime timestamp;
  MessageType type;
  String userId;
  String userName;

  Message(this.userId, this.userName, {this.timestamp}) {
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

class TextMessage extends Message {
  final String text;

  TextMessage(this.text, String userId, String userName, {DateTime timestamp})
      : super(userId, userName, timestamp: timestamp) {
    type = MessageType.text;
  }

  factory TextMessage.fromMap(Map map) {
    return TextMessage(
      map['text'],
      map['userId'],
      map['userName'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'type': 'text',
        'text': text,
        'timestamp': timestamp.toIso8601String(),
      };

  Widget displayMessage(isMine) {
    return Container(
      child: Text(
        '$text',
        overflow: TextOverflow.ellipsis,
        maxLines: 5,
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
    return 'TextMessage{timestamp: $timestamp, text: $text}';
  }
}

class PhotoMessage extends Message {
  final String photoUrl;

  PhotoMessage(this.photoUrl, String userId, String userName,
      {DateTime timestamp})
      : super(userId, userName, timestamp: timestamp) {
    type = MessageType.photo;
  }

  factory PhotoMessage.fromMap(Map map) {
    return PhotoMessage(
      map['photoUrl'],
      map['userId'],
      map['userName'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'type': 'photo',
        'photoUrl': photoUrl,
        'timestamp': timestamp.toIso8601String(),
      };

  Widget displayMessage(isMine) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
      child: CachedNetworkImage(
        placeholder: (context, url) => SizedBox(
              child: CircularProgressIndicator(),
              width: 20,
              height: 20,
            ),
        imageUrl: photoUrl,
        fit: BoxFit.cover,
        width: 150,
        height: 150,
      ),
    );
  }

  @override
  String toString() {
    return 'PhotoMessage{timestamp: $timestamp, photoUrl: $photoUrl}';
  }
}