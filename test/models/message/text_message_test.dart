import 'package:flutter/widgets.dart';
import 'package:flutter_chat/src/models/message/message.dart';
import 'package:flutter_chat/src/models/message/text_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Text Message constructor with all parameters', () {
    const String text = 'msgTxt';
    const String userId = 'uid';
    final DateTime dateTime = DateTime(2019);
    final TextMessage txtMsg = TextMessage(text, userId, timestamp: dateTime);

    expect(txtMsg.userId, userId);
    expect(txtMsg.text, text);
    expect(txtMsg.type, MessageType.text);
    expect(txtMsg.timestamp.millisecondsSinceEpoch,
        dateTime.millisecondsSinceEpoch);
  });

  test('Text Message constructor without timestamp', () {
    const String text = 'msgTxt';
    const String userId = 'uid';
    final TextMessage txtMsg = TextMessage(text, userId);

    expect(txtMsg.userId, userId);
    expect(txtMsg.text, text);
    expect(txtMsg.type, MessageType.text);
    expect(txtMsg.timestamp, isInstanceOf<DateTime>());
  });

  test('TextMessage.fromMap', () {
    const String text = 'msgTxt';
    const String userId = 'uid';
    final DateTime dateTime = DateTime(2019);
    final Map<String, dynamic> map = {
      'text': text,
      'userId': userId,
      'timestamp': dateTime.millisecondsSinceEpoch
    };
    final TextMessage txtMsg = TextMessage.fromMap(map);

    expect(txtMsg.userId, userId);
    expect(txtMsg.text, text);
    expect(txtMsg.type, MessageType.text);
    expect(txtMsg.timestamp, dateTime);
  });

  test('TextMessage.toJson', () {
    const String text = 'msgTxt';
    const String userId = 'uid';
    final DateTime dateTime = DateTime(2019);
    final TextMessage txtMsg = TextMessage(text, userId, timestamp: dateTime);

    final Map<String, dynamic> json = txtMsg.toJson();

    expect(json, {
      'userId': userId,
      'type': 'text',
      'text': text,
      'timestamp': dateTime.millisecondsSinceEpoch,
    });
  });

  test('TextMessage.displayMessage() shoud return a Widget when isMine is true',
      () {
    const String text = 'msgTxt';
    const String userId = 'uid';
    final DateTime dateTime = DateTime(2019);
    final TextMessage txtMsg = TextMessage(text, userId, timestamp: dateTime);

    const bool isMine = true;
    BuildContext context;

    expect(
        txtMsg.displayMessage(context, isMine: isMine), isInstanceOf<Widget>());
  });

  test(
      'TextMessage.displayMessage() shoud return a Widget when isMine is false',
      () {
    const String text = 'msgTxt';
    const String userId = 'uid';
    final DateTime dateTime = DateTime(2019);
    final TextMessage txtMsg = TextMessage(text, userId, timestamp: dateTime);

    const bool isMine = false;
    BuildContext context;
    expect(
        txtMsg.displayMessage(context, isMine: isMine), isInstanceOf<Widget>());
  });

  test('TextMessage.toString', () {
    const String text = 'msgTxt';
    const String userId = 'uid';
    final DateTime dateTime = DateTime(2019);
    final TextMessage txtMsg = TextMessage(text, userId, timestamp: dateTime);

    expect(txtMsg.toString(),
        'TextMessage{type: ${MessageType.text}, userId: $userId timestamp: $dateTime, text: $text}');
  });
}
