import 'package:flutter/widgets.dart';
import 'package:flutter_chat/src/models/message/message.dart';
import 'package:flutter_chat/src/models/message/photo_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PhotoMessage constructor with all parameters', () {
    String photoUrl = 'photoUrl';
    String userId = 'uid';
    DateTime dateTime = DateTime.now();
    PhotoMessage photoMessage =
        PhotoMessage(photoUrl, userId, timestamp: dateTime);

    expect(photoMessage.userId, userId);
    expect(photoMessage.photoUrl, photoUrl);
    expect(photoMessage.type, MessageType.photo);
    expect(photoMessage.timestamp, dateTime);
  });

  test('PhotoMessage constructor without timestamp', () {
    String photoUrl = 'photoUrl';
    String userId = 'uid';
    PhotoMessage photoMessage = PhotoMessage(
      photoUrl,
      userId,
    );

    expect(photoMessage.userId, userId);
    expect(photoMessage.photoUrl, photoUrl);
    expect(photoMessage.type, MessageType.photo);
    expect(photoMessage.timestamp, isInstanceOf<DateTime>());
  });

  test('PhotoMessage.fromMap', () {
    String photoUrl = 'photoUrl';
    String userId = 'uid';
    DateTime dateTime = DateTime.now();

    Map<String, dynamic> map = {
      "photoUrl": photoUrl,
      "userId": userId,
      "timestamp": dateTime.millisecondsSinceEpoch
    };
    PhotoMessage photoMessage = PhotoMessage.fromMap(map);

    expect(photoMessage.userId, userId);
    expect(photoMessage.photoUrl, photoUrl);
    expect(photoMessage.type, MessageType.photo);
    expect(photoMessage.timestamp, dateTime);
  });

  test('PhotoMessage.toJson', () {
    String photoUrl = 'photoUrl';
    String userId = 'uid';
    DateTime dateTime = DateTime.now();
    PhotoMessage photoMessage =
        PhotoMessage(photoUrl, userId, timestamp: dateTime);

    Map<String, dynamic> json = photoMessage.toJson();

    expect(json, {
      'userId': userId,
      'type': 'photo',
      'photoUrl': photoUrl,
      'timestamp': dateTime.millisecondsSinceEpoch,
    });
  });

  test(
      'PhotoMessage.displayMessage() shoud return a Widget when isMine is true',
      () {
    String photoUrl = 'photoUrl';
    String userId = 'uid';
    DateTime dateTime = DateTime.now();
    PhotoMessage photoMessage =
        PhotoMessage(photoUrl, userId, timestamp: dateTime);

    bool isMine = true;
    BuildContext context;

    expect(
        photoMessage.displayMessage(isMine, context), isInstanceOf<Widget>());
  });

  test(
      'PhotoMessage.displayMessage() shoud return a Widget when isMine is false',
      () {
    String photoUrl = 'photoUrl';
    String userId = 'uid';
    DateTime dateTime = DateTime.now();
    PhotoMessage photoMessage =
        PhotoMessage(photoUrl, userId, timestamp: dateTime);

    bool isMine = false;
    BuildContext context;

    expect(
        photoMessage.displayMessage(isMine, context), isInstanceOf<Widget>());
  });

  test('TextMessage.toString', () {
    String photoUrl = 'photoUrl';
    String userId = 'uid';
    DateTime dateTime = DateTime.now();
    PhotoMessage photoMessage =
        PhotoMessage(photoUrl, userId, timestamp: dateTime);

    expect(photoMessage.toString(),
        'PhotoMessage{type: ${MessageType.photo}, userId: $userId timestamp: $dateTime, photoUrl: $photoUrl}');
  });
}
