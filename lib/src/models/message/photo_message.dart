import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/src/models/message/message.dart';

class PhotoMessage extends Message {
  final String photoUrl;

  PhotoMessage(this.photoUrl, String userId, {DateTime timestamp})
      : super(userId, timestamp: timestamp) {
    type = MessageType.photo;
  }

  factory PhotoMessage.fromMap(Map map) {
    return PhotoMessage(
      map['photoUrl'],
      map['userId'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'type': 'photo',
        'photoUrl': photoUrl,
        'timestamp': timestamp.toIso8601String(),
      };

  Widget displayMessage(isMine) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
    return 'PhotoMessage{type: ${MessageType.photo}, userId: $userId timestamp: $timestamp, photoUrl: $photoUrl}';
  }
}
