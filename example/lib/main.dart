import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';

void main() {
  runApp(ChatDemoApp());
}

class ChatDemoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatDemoAppState();
}

class _ChatDemoAppState extends State<ChatDemoApp> {
  Chat _chat = Chat();
  bool _isChatReady = false;

  _ChatDemoAppState();

  @override
  void initState() {
    FirebaseApp app = FirebaseApp.instance;
    FirebaseDatabase database = FirebaseDatabase(app: app);
    database.setPersistenceEnabled(false);
    _initChat(database);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _isChatReady
          ? ChatsPage()
          : Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
    );
  }

  /*
  Future<FirebaseUser> _loginExternal(String userName) async {
    Dio dio = Dio();
    Response response = await dio.post(
        'https://us-central1-gamification-d5b83.cloudfunctions.net/testAuth',
        data: {'userName': userName});
    final token = response.data;
    print('Token: $token');
    final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser fbUser =
        await auth.signInWithCustomToken(token: token).catchError((error) {
      throw Exception('Error login with external solution');
    });
    print(fbUser);
    return fbUser;
  }
  */

  _initChat(FirebaseDatabase database) async {
    //FirebaseUser fbUser = await _loginExternal('alexia');
    //final user = User(firstName: 'fred', lastName: 'Visticot');
    final user = User(firstName: 'alexia', lastName: 'Frit');
    try {
      await _chat.init(database, user: user);
      _isChatReady = true;
      setState(() {});
      _setupNotifications();
    } catch (e) {
      print("Error: $e");
    }
  }

  void _setupNotifications() {
    final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage received: $message");
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      print("Push Messaging token: $token");
      _chat.setPushNotificationToken(token);
    });
  }
}
