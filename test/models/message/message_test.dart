import 'package:flutter_chat/src/models/message/message.dart';
import 'package:flutter_chat/src/models/message/photo_message.dart';
import 'package:flutter_chat/src/models/message/text_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Message.fromMap() given text type return TextMessage', () {
    String text = 'msgTxt';
    String userId = 'uid';
    String userName = 'uName';
    DateTime dateTime = DateTime.now();

    Map<String, dynamic> map = {
      "type": "text",
      "text": text,
      "userId": userId,
      "userName": userName,
      "timestamp": dateTime.millisecondsSinceEpoch
    };

    expect(Message.fromMap(map), isInstanceOf<TextMessage>());
  });

  test('Message.fromMap() given text type return TextMessage', () {
    String photoUrl = 'photoUrl';
    String userId = 'uid';
    String userName = 'uName';
    DateTime dateTime = DateTime.now();

    Map<String, dynamic> map = {
      "type": "photo",
      "photoUrl": photoUrl,
      "userId": userId,
      "userName": userName,
      "timestamp": dateTime.millisecondsSinceEpoch
    };

    expect(Message.fromMap(map), isInstanceOf<PhotoMessage>());
  });
}
