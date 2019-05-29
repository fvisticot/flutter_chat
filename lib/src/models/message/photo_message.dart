import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/src/group_chat/photo_viewer.dart';
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
      timestamp:
          DateTime.fromMillisecondsSinceEpoch(map['timestamp'], isUtc: true)
              .toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'type': 'photo',
        'photoUrl': photoUrl,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  Widget displayMessage(isMine, context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HeroPhotoViewWrapper(
                      heroTag: photoUrl,
                      imageProvider: CachedNetworkImageProvider(photoUrl),
                    ),
              ));
        },
        child: Hero(
          tag: photoUrl,
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
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'PhotoMessage{type: ${MessageType.photo}, userId: $userId timestamp: $timestamp, photoUrl: $photoUrl}';
  }
}
