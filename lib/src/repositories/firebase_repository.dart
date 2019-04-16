import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat/src/models/models.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data_repository.dart';

class FirebaseRepository implements DataRepository {
  final FirebaseDatabase firebaseDatabase;

  FirebaseRepository(this.firebaseDatabase) : assert(firebaseDatabase != null);

  Future<User> initChat(String userName) async {
    initializeDateFormatting("fr_FR", null);
    final FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser == null) {
      //throw ChatException('User not authenticated on Firebase.');
      throw Exception('User not authenticated on Firebase.');
    }
    User currentUser;
    final User userDb = await _userFromId(firebaseUser.uid);
    if (userDb == null) {
      if (firebaseUser == null || userName == null) {
        //throw ChatException('User info must be provided (userName) to create the user in DB.');
        throw Exception(
            'User info must be provided (userName) to create the user in DB.');
      }
      currentUser = User(firebaseUser.uid, userName);
      print('User not present in DB, creating user ($currentUser).');
      await _createUser(currentUser);
    } else {
      currentUser = userDb;
      print('User already present in DB.');
    }
    _initPresence(currentUser.id);
    _setupNotifications(currentUser.id);
    return currentUser;
  }

  Future<User> _userFromId(String userId) async {
    DataSnapshot snapshot =
        await firebaseDatabase.reference().child('users').child(userId).once();
    Map map = snapshot.value;
    map['id'] = snapshot.key;
    if (map != null) {
      User user = User.fromMap(map);
      return user;
    } else {
      return null;
    }
  }

  Future<void> _createUser(User user) {
    return firebaseDatabase
        .reference()
        .child('users')
        .child(user.id)
        .set(user.toJson());
  }

  Future<void> _initPresence(String uid) async {
    DatabaseReference amOnline =
        firebaseDatabase.reference().child('.info/connected');
    DatabaseReference userRef =
        firebaseDatabase.reference().child('presences/$uid');
    amOnline.onValue.listen((event) {
      print('Presence changed: ${event.snapshot.value}');
      userRef.onDisconnect().remove();
      userRef.set(true);
    });
  }

  Future<void> _setupNotifications(String uid) async {
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

    String token = await _firebaseMessaging.getToken();
    print("Push Messaging token: $token");
    await _setPushNotificationToken(token, uid);
  }

  Future<void> _setPushNotificationToken(String token, String uid) async {
    return await firebaseDatabase
        .reference()
        .child('users-pushTokens')
        .update({'$uid': token});
  }

  Future<Group> getGroupInfo(String groupId) async {
    DataSnapshot groupUsersSnapshot = await firebaseDatabase
        .reference()
        .child('groups-users/$groupId')
        .once();

    if (groupUsersSnapshot.value != null) {
      print(groupUsersSnapshot.value);

      Map<String, String> users = Map<String, String>.from(groupUsersSnapshot.value);

      String title = '';
      if (users.length > 2) {
        DataSnapshot groupSnapshot =
        await firebaseDatabase.reference().child('groups/$groupId').once();
        title = groupSnapshot.value['title'];
      }
      return (title != '')
          ? Group(groupId, users, title: title)
          : Group(groupId, users);

/*      List<User> users = [];
      for (String userKey in groupUsersSnapshot.value.keys) {
        User user = await _userFromId(userKey);
        users.add(user);
      }

      String title = '';
      if (users.length > 2) {
        DataSnapshot groupSnapshot =
            await firebaseDatabase.reference().child('groups/$groupId').once();
        title = groupSnapshot.value['title'];
      }
      return (title != '')
          ? Group(groupId, users, title: title)
          : Group(groupId, users);*/
    } else {
      throw Exception('Unknown group');
    }
  }

  Future<List<String>> getGroupUsers(String groupId) async {
    DataSnapshot groupUsersSnapshot = await firebaseDatabase
        .reference()
        .child('groups-users/$groupId')
        .once();
    List<String> usersId = [];
    groupUsersSnapshot.value.forEach((userKey, userValue) {
      usersId.add(userKey);
    });
    return usersId;
  }

  Future<User> getUserFromId(String userId) async {
    DataSnapshot userSnapshot =
        await firebaseDatabase.reference().child('users/$userId').once();

    Map map = userSnapshot.value;
    map['id'] = userSnapshot.key;
    if (map != null) {
      User user = User.fromMap(map);
      return user;
    } else {
      return null;
    }
  }

  Stream<List<Message>> streamOfMessages(String groupId) {
    try {
      return firebaseDatabase
          .reference()
          .child('groups-messages/$groupId')
          .onValue
          .map((event) {
        List<Message> messages = [];
        Map<dynamic, dynamic> map = event.snapshot.value;
        List<dynamic> list = map.keys.toList()
          ..sort((a, b) {
            return b.compareTo(a);
          });
        LinkedHashMap sortedMap = LinkedHashMap.fromIterable(list,
            key: (k) => k, value: (k) => map[k]);

        sortedMap.forEach((messageKey, messageValue) {
          messages.add(Message.fromMap(messageValue));
        });
        return messages;
      });
    } catch (e) {
      print(e);
      throw Exception();
    }
  }

  Stream<bool> userPresence(userId) {
    return firebaseDatabase
        .reference()
        .child('presences')
        .child(userId)
        .onValue
        .map((event) {
      print(event.snapshot.value);
      return (event.snapshot.value == true);
    }
    );
  }

  sendMessage(String groupId, Message message) {
    firebaseDatabase
        .reference()
        .child('groups-messages')
        .child(groupId)
        .push()
        .update(message.toJson());
  }

  StorageUploadTask storeFileTask(String filename, File file) {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(filename);
    return storageReference.putFile(file);
  }

  Stream<List<String>> typingUsers(String groupId, User currentUser) {
    try {
      return firebaseDatabase
          .reference()
          .child('groups-activities')
          .child(groupId)
          .onValue
          .map((event) {
        List<String> userNames = [];
        if (event.snapshot.value != null) {
          event.snapshot.value.forEach((activityKey, activityValue) {
            if (currentUser.id != activityKey) {
              userNames.add(activityValue);
            }
          });
        }
        return userNames;
      });
    } catch (e) {
      print(e);
      throw Exception();
    }
  }

  Future<void> isTyping(String groupId, User writer, bool isTyping) async {
    DatabaseReference activityRef =
        firebaseDatabase.reference().child('groups-activities').child(groupId);

    if (isTyping) {
      await activityRef.update({writer.id: writer.userName});
      activityRef.child(writer.id).onDisconnect().remove();
    } else {
      return await activityRef.child(writer.id).remove();
    }
  }
}
