import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat/flutter_chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';

void main() {
  FirebaseDatabase _database;
  Chat _chat;

  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  group('Chat tests', () {
    setUpAll(() async {
      print('setupAll');
      FirebaseApp app = FirebaseApp.instance;
      _database = FirebaseDatabase(app: app);
      _database.setPersistenceEnabled(false);
      _chat = Chat();
      await _chat.init(_database);
    });

    tearDownAll(() async {
      print('tearDownAll');
    });

    test('groupById', () {
      _chat.group('8');
    });
  });
}
