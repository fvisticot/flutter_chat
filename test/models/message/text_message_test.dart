import 'package:flutter/widgets.dart';
import 'package:flutter_chat/src/models/message/message.dart';
import 'package:flutter_chat/src/models/message/text_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Text Message constructor with all parameters', () {
    String text = 'msgTxt';
    String userId = 'uid';
    String userName = 'uName';
    DateTime dateTime = DateTime.now();
    TextMessage txtMsg =
        TextMessage(text, userId, userName, timestamp: dateTime);

    expect(txtMsg.userId, userId);
    expect(txtMsg.userName, userName);
    expect(txtMsg.text, text);
    expect(txtMsg.type, MessageType.text);
    expect(txtMsg.timestamp, dateTime);
  });

  test('Text Message constructor without timestamp', () {
    String text = 'msgTxt';
    String userId = 'uid';
    String userName = 'uName';
    TextMessage txtMsg = TextMessage(text, userId, userName);

    expect(txtMsg.userId, userId);
    expect(txtMsg.userName, userName);
    expect(txtMsg.text, text);
    expect(txtMsg.type, MessageType.text);
    expect(txtMsg.timestamp, isInstanceOf<DateTime>());
  });

  test('TextMessage.fromMap', () {
    String text = 'msgTxt';
    String userId = 'uid';
    String userName = 'uName';
    DateTime dateTime = DateTime.now();
    Map<String, dynamic> map = {
      "text": text,
      "userId": userId,
      "userName": userName,
      "timestamp": dateTime.toIso8601String()
    };
    TextMessage txtMsg = TextMessage.fromMap(map);

    expect(txtMsg.userId, userId);
    expect(txtMsg.userName, userName);
    expect(txtMsg.text, text);
    expect(txtMsg.type, MessageType.text);
    expect(txtMsg.timestamp, dateTime);
  });

  test('TextMessage.toJson', () {
    String text = 'msgTxt';
    String userId = 'uid';
    String userName = 'uName';
    DateTime dateTime = DateTime.now();
    TextMessage txtMsg =
        TextMessage(text, userId, userName, timestamp: dateTime);

    Map<String, dynamic> json = txtMsg.toJson();

    expect(json, {
      'userId': userId,
      'userName': userName,
      'type': 'text',
      'text': text,
      'timestamp': dateTime.toIso8601String(),
    });
  });

  test('TextMessage.displayMessage() shoud return a Widget when isMine is true',
      () {
    String text = 'msgTxt';
    String userId = 'uid';
    String userName = 'uName';
    DateTime dateTime = DateTime.now();
    TextMessage txtMsg =
        TextMessage(text, userId, userName, timestamp: dateTime);

    bool isMine = true;

    expect(txtMsg.displayMessage(isMine), isInstanceOf<Widget>());
  });

  test(
      'TextMessage.displayMessage() shoud return a Widget when isMine is false',
      () {
    String text = 'msgTxt';
    String userId = 'uid';
    String userName = 'uName';
    DateTime dateTime = DateTime.now();
    TextMessage txtMsg =
        TextMessage(text, userId, userName, timestamp: dateTime);

    bool isMine = false;

    expect(txtMsg.displayMessage(isMine), isInstanceOf<Widget>());
  });

  test('TextMessage.toString', () {
    String text = 'msgTxt';
    String userId = 'uid';
    String userName = 'uName';
    DateTime dateTime = DateTime.now();
    TextMessage txtMsg =
        TextMessage(text, userId, userName, timestamp: dateTime);

    expect(txtMsg.toString(),
        'TextMessage{type: ${MessageType.text}, userId: $userId timestamp: $dateTime, text: $text}');
  });
}
