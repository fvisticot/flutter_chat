import 'package:flutter/widgets.dart';
import 'package:flutter_chat/src/models/message/message.dart';
import 'package:flutter_chat/src/models/message/text_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Text Message constructor with all parameters', () {
    String text = 'msgTxt';
    String userId = 'uid';
    DateTime dateTime = DateTime.now();
    TextMessage txtMsg = TextMessage(text, userId, timestamp: dateTime);

    expect(txtMsg.userId, userId);
    expect(txtMsg.text, text);
    expect(txtMsg.type, MessageType.text);
    expect(txtMsg.timestamp.millisecondsSinceEpoch,
        dateTime.millisecondsSinceEpoch);
  });

  test('Text Message constructor without timestamp', () {
    String text = 'msgTxt';
    String userId = 'uid';
    TextMessage txtMsg = TextMessage(text, userId);

    expect(txtMsg.userId, userId);
    expect(txtMsg.text, text);
    expect(txtMsg.type, MessageType.text);
    expect(txtMsg.timestamp, isInstanceOf<DateTime>());
  });

  test('TextMessage.fromMap', () {
    String text = 'msgTxt';
    String userId = 'uid';
    DateTime dateTime = DateTime.now();
    Map<String, dynamic> map = {
      "text": text,
      "userId": userId,
      "timestamp": dateTime.millisecondsSinceEpoch
    };
    TextMessage txtMsg = TextMessage.fromMap(map);

    expect(txtMsg.userId, userId);
    expect(txtMsg.text, text);
    expect(txtMsg.type, MessageType.text);
    expect(txtMsg.timestamp, dateTime);
  });

  test('TextMessage.toJson', () {
    String text = 'msgTxt';
    String userId = 'uid';
    DateTime dateTime = DateTime.now();
    TextMessage txtMsg = TextMessage(text, userId, timestamp: dateTime);

    Map<String, dynamic> json = txtMsg.toJson();

    expect(json, {
      'userId': userId,
      'type': 'text',
      'text': text,
      'timestamp': dateTime.millisecondsSinceEpoch,
    });
  });

  test('TextMessage.displayMessage() shoud return a Widget when isMine is true',
      () {
    String text = 'msgTxt';
    String userId = 'uid';
    DateTime dateTime = DateTime.now();
    TextMessage txtMsg = TextMessage(text, userId, timestamp: dateTime);

    bool isMine = true;
    BuildContext context;

    expect(txtMsg.displayMessage(isMine, context), isInstanceOf<Widget>());
  });

  test(
      'TextMessage.displayMessage() shoud return a Widget when isMine is false',
      () {
    String text = 'msgTxt';
    String userId = 'uid';
    DateTime dateTime = DateTime.now();
    TextMessage txtMsg = TextMessage(text, userId, timestamp: dateTime);

    bool isMine = false;
    BuildContext context;
    expect(txtMsg.displayMessage(isMine, context), isInstanceOf<Widget>());
  });

  test('TextMessage.toString', () {
    String text = 'msgTxt';
    String userId = 'uid';
    DateTime dateTime = DateTime.now();
    TextMessage txtMsg = TextMessage(text, userId, timestamp: dateTime);

    expect(txtMsg.toString(),
        'TextMessage{type: ${MessageType.text}, userId: $userId timestamp: $dateTime, text: $text}');
  });
}
