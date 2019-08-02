import 'package:flutter/widgets.dart';
import 'package:flutter_chat/src/models/message/message.dart';
import 'package:flutter_chat/src/models/message/photo_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PhotoMessage constructor with all parameters', () {
    const String photoUrl = 'photoUrl';
    const String userId = 'uid';
    final DateTime dateTime = DateTime(2019);
    final PhotoMessage photoMessage =
        PhotoMessage(photoUrl, userId, timestamp: dateTime);

    expect(photoMessage.userId, userId);
    expect(photoMessage.photoUrl, photoUrl);
    expect(photoMessage.type, MessageType.photo);
    expect(photoMessage.timestamp, dateTime);
  });

  test('PhotoMessage constructor without timestamp', () {
    const String photoUrl = 'photoUrl';
    const String userId = 'uid';
    final PhotoMessage photoMessage = PhotoMessage(
      photoUrl,
      userId,
    );

    expect(photoMessage.userId, userId);
    expect(photoMessage.photoUrl, photoUrl);
    expect(photoMessage.type, MessageType.photo);
    expect(photoMessage.timestamp, isInstanceOf<DateTime>());
  });

  test('PhotoMessage.fromMap', () {
    const String photoUrl = 'photoUrl';
    const String userId = 'uid';
    final DateTime dateTime = DateTime(2019);

    final Map<String, dynamic> map = {
      'photoUrl': photoUrl,
      'userId': userId,
      'timestamp': dateTime.millisecondsSinceEpoch
    };
    final PhotoMessage photoMessage = PhotoMessage.fromMap(map);

    expect(photoMessage.userId, userId);
    expect(photoMessage.photoUrl, photoUrl);
    expect(photoMessage.type, MessageType.photo);
    expect(photoMessage.timestamp, dateTime);
  });

  test('PhotoMessage.toJson', () {
    const String photoUrl = 'photoUrl';
    const String userId = 'uid';
    final DateTime dateTime = DateTime(2019);
    final PhotoMessage photoMessage =
        PhotoMessage(photoUrl, userId, timestamp: dateTime);

    final Map<String, dynamic> json = photoMessage.toJson();

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
    const String photoUrl = 'photoUrl';
    const String userId = 'uid';
    final DateTime dateTime = DateTime(2019);
    final PhotoMessage photoMessage =
        PhotoMessage(photoUrl, userId, timestamp: dateTime);

    const bool isMine = true;
    BuildContext context;

    expect(photoMessage.displayMessage(context, isMine: isMine),
        isInstanceOf<Widget>());
  });

  test(
      'PhotoMessage.displayMessage() shoud return a Widget when isMine is false',
      () {
    const String photoUrl = 'photoUrl';
    const String userId = 'uid';
    final DateTime dateTime = DateTime(2019);
    final PhotoMessage photoMessage =
        PhotoMessage(photoUrl, userId, timestamp: dateTime);

    const bool isMine = false;
    BuildContext context;

    expect(photoMessage.displayMessage(context, isMine: isMine),
        isInstanceOf<Widget>());
  });

  test('TextMessage.toString', () {
    const String photoUrl = 'photoUrl';
    const String userId = 'uid';
    final DateTime dateTime = DateTime(2019);
    final PhotoMessage photoMessage =
        PhotoMessage(photoUrl, userId, timestamp: dateTime);

    expect(photoMessage.toString(),
        'PhotoMessage{type: ${MessageType.photo}, userId: $userId timestamp: $dateTime, photoUrl: $photoUrl}');
  });
}
