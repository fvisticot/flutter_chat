import 'package:flutter_chat/src/models/message/message.dart';
import 'package:flutter_chat/src/models/message/photo_message.dart';
import 'package:flutter_chat/src/models/message/text_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Message.fromMap() given text type return TextMessage', () {
    const String text = 'msgTxt';
    const String userId = 'uid';
    const String userName = 'uName';
    final DateTime dateTime = DateTime.now();

    final Map<String, dynamic> map = {
      'type': 'text',
      'text': text,
      'userId': userId,
      'userName': userName,
      'timestamp': dateTime.millisecondsSinceEpoch
    };

    expect(Message.fromMap(map), isInstanceOf<TextMessage>());
  });

  test('Message.fromMap() given text type return TextMessage', () {
    const String photoUrl = 'photoUrl';
    const String userId = 'uid';
    const String userName = 'uName';
    final DateTime dateTime = DateTime.now();

    final Map<String, dynamic> map = {
      'type': 'photo',
      'photoUrl': photoUrl,
      'userId': userId,
      'userName': userName,
      'timestamp': dateTime.millisecondsSinceEpoch
    };

    expect(Message.fromMap(map), isInstanceOf<PhotoMessage>());
  });
}
