import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat/src/models/models.dart';

class FirebaseChatService implements ChatService {
  FirebaseChatService(this.firebaseDatabase) : assert(firebaseDatabase != null);
  final FirebaseDatabase firebaseDatabase;

  @override
  Future<User> initChat() async {
    final FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser == null) {
      throw Exception('User not authenticated on Firebase.');
    }
    final User userDb = await _userFromId(firebaseUser.uid);
    if (userDb == null) {
      throw Exception('User must exist in database.');
    } else {
      print('User present in DB.');
    }
    _initPresence(userDb.id);
    _setupNotifications(userDb.id);
    return userDb;
  }

  Future<User> _userFromId(String userId) async {
    final DataSnapshot snapshot =
        await firebaseDatabase.reference().child('users').child(userId).once();
    final Map map = snapshot.value;
    if (map != null) {
      map['id'] = snapshot.key;
      final User user = User.fromMap(map);
      return user;
    } else {
      return null;
    }
  }

  void _initPresence(String uid) {
    final DatabaseReference amOnline =
        firebaseDatabase.reference().child('.info/connected');
    final DatabaseReference userRef =
        firebaseDatabase.reference().child('presences/$uid');
    amOnline.onValue.listen((event) {
      print('Presence changed: ${event.snapshot.value}');
      userRef.onDisconnect().remove();
      userRef.set(true);
    });
  }

  @override
  Future<void> setPresence({@required bool presence}) async {
    final FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser != null) {
      final DatabaseReference userRef =
          firebaseDatabase.reference().child('presences/${firebaseUser.uid}');
      if (presence) {
        userRef.set(true);
      } else {
        userRef.remove();
      }
    }
  }

  Future<void> _setupNotifications(String uid) async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage received: $message');
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch: $message');
        return;
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume: $message');
        return;
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Settings registered: $settings');
    });

    final String token = await _firebaseMessaging.getToken();
    print('Push Messaging token: $token');
    await _setPushNotificationToken(uid, token);
  }

  Future<void> _setPushNotificationToken(String uid, String token) async {
    return firebaseDatabase
        .reference()
        .child('users-pushTokens')
        .update({'$uid': token});
  }

  @override
  Future<Group> getGroupInfo(String groupId) async {
    final DataSnapshot groupUsersSnapshot = await firebaseDatabase
        .reference()
        .child('groups-users/$groupId')
        .once();

    if (groupUsersSnapshot.value != null) {
      final Map<String, String> users =
          Map<String, String>.from(groupUsersSnapshot.value);

      String title = '';
      if (users.length > 2) {
        final DataSnapshot groupSnapshot =
            await firebaseDatabase.reference().child('groups/$groupId').once();
        title = groupSnapshot.value['title'];
      }
      return (title != '')
          ? Group(groupId, users, title: title)
          : Group(groupId, users);
    } else {
      throw Exception('Unknown group');
    }
  }

  @override
  Future<List<String>> getGroupUsers(String groupId) async {
    final DataSnapshot groupUsersSnapshot = await firebaseDatabase
        .reference()
        .child('groups-users/$groupId')
        .once();
    final List<String> usersId = [];
    if (groupUsersSnapshot.value != null) {
      groupUsersSnapshot.value.forEach((userKey, userValue) {
        usersId.add(userKey);
      });
    }
    return usersId;
  }

  @override
  Future<User> getUserFromId(String userId) async {
    final DataSnapshot userSnapshot =
        await firebaseDatabase.reference().child('users/$userId').once();

    final Map map = userSnapshot.value;
    if (map != null) {
      map['id'] = userSnapshot.key;
      final User user = User.fromMap(map);
      return user;
    } else {
      return null;
    }
  }

  @override
  Stream<List<Message>> streamOfMessages(String groupId) {
    try {
      return firebaseDatabase
          .reference()
          .child('groups-messages/$groupId')
          .limitToLast(50)
          .onValue
          .map((event) {
        final List<Message> messages = [];
        final Map<dynamic, dynamic> map = event.snapshot.value;
        if (map != null) {
          final List<dynamic> list = map.keys.toList()
            ..sort((a, b) {
              return b.compareTo(a);
            });
          final LinkedHashMap sortedMap = LinkedHashMap.fromIterable(list,
              key: (k) => k, value: (k) => map[k]);
          sortedMap.forEach((messageKey, messageValue) {
            messages.add(Message.fromMap(messageValue));
          });
        }
        return messages;
      });
    } catch (e) {
      print(e);
      throw Exception();
    }
  }

  @override
  Stream<bool> userPresence(String userId) {
    return firebaseDatabase
        .reference()
        .child('presences')
        .child(userId)
        .onValue
        .map((event) {
      print(event.snapshot.value);
      return event.snapshot.value == true;
    });
  }

  @override
  void sendMessage(String groupId, Message message) {
    firebaseDatabase
        .reference()
        .child('groups-messages')
        .child(groupId)
        .push()
        .update(message.toJson());
  }

  @override
  StorageUploadTask storeFileTask(String filename, File file) {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child(filename);
    return storageReference.putFile(file);
  }

  @override
  Stream<List<String>> typingUsers(String groupId, User currentUser) {
    try {
      return firebaseDatabase
          .reference()
          .child('groups-activities')
          .child(groupId)
          .onValue
          .map((event) {
        final List<String> userNames = [];
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

  @override
  Future<void> isTyping(String groupId, User writer,
      {@required bool isTyping}) async {
    final DatabaseReference activityRef =
        firebaseDatabase.reference().child('groups-activities').child(groupId);

    if (isTyping) {
      await activityRef.update({writer.id: writer.userName});
      activityRef.child(writer.id).onDisconnect().remove();
    } else {
      return activityRef.child(writer.id).remove();
    }
  }

  @override
  Future<Map<String, String>> searchUsersByName(String name) async {
    Query query = firebaseDatabase
        .reference()
        .child('users')
        .orderByChild('userNameLowerCase');

    if (name != null) {
      query = query
          .startAt(name.toLowerCase())
          .endAt('${name.toLowerCase()}\uf8ff');
    }
    final Map<String, String> usersMap = {};

    return query.once().then((snap) {
      final snapMap = snap.value;
      if (snapMap != null) {
        snapMap.forEach((key, value) {
          usersMap.addAll({key: value['userName']});
        });
        return usersMap;
      } else {
        return {};
      }
    });
  }

  @override
  Future<String> getDuoGroupId(String currentUserId, String userId) async {
    final Query query = firebaseDatabase
        .reference()
        .child('users-groups/$currentUserId')
        .orderByChild('duo')
        .equalTo(userId);

    return query.once().then((snap) {
      final snapMap = snap.value;
      if (snapMap != null) {
        return snap.value.keys.first;
      } else {
        return null;
      }
    });
  }

  @override
  Future<String> createDuoGroup(String currentUserId, String userId) async {
    final String groupId =
        firebaseDatabase.reference().child('groups').push().key;
    final DatabaseReference groupsUsersRef =
        firebaseDatabase.reference().child('groups-users').child(groupId);
    final List<Future> futures = [];

    firebaseDatabase
        .reference()
        .child('users')
        .child(userId)
        .once()
        .then((userSnapshot) {
      futures
          .add(groupsUsersRef.update({userId: userSnapshot.value['userName']}));
      firebaseDatabase
          .reference()
          .child('users-groups')
          .child(currentUserId)
          .child(groupId)
          .set({
        'duo': userId,
        'lastMsg': '',
        'lastMsgTimestamp': DateTime.now().millisecondsSinceEpoch,
        'title': userSnapshot.value['userName']
      });
    });

    firebaseDatabase
        .reference()
        .child('users')
        .child(currentUserId)
        .once()
        .then((userSnapshot) {
      futures.add(groupsUsersRef
          .update({currentUserId: userSnapshot.value['userName']}));
      firebaseDatabase
          .reference()
          .child('users-groups')
          .child(userId)
          .child(groupId)
          .set({
        'duo': currentUserId,
        'lastMsg': '',
        'lastMsgTimestamp': DateTime.now().millisecondsSinceEpoch,
        'title': userSnapshot.value['userName']
      });
    });

    await Future.wait(futures);
    return groupId;
  }

  @override
  Stream<Map<String, dynamic>> streamOfUserDiscussions(String currentUserId) {
    return firebaseDatabase
        .reference()
        .child('users-groups')
        .child(currentUserId)
        .onValue
        .map((event) {
      final Map<String, dynamic> discussions = {};
      final Map<dynamic, dynamic> map = event.snapshot.value;
      if (map != null) {
        final List<dynamic> list = map.keys.toList()
          ..sort((a, b) {
            return map[b]['lastMsgTimestamp']
                .compareTo(map[a]['lastMsgTimestamp']);
          });
        final LinkedHashMap sortedMap = LinkedHashMap.fromIterable(list,
            key: (k) => k, value: (k) => map[k]);
        print(sortedMap);
        sortedMap.forEach((groupKey, groupValue) {
          discussions.addAll({
            groupKey: {
              'title': groupValue['title'],
              'lastMsg': groupValue['lastMsg']
            }
          });
        });
      }
      return discussions;
    });
  }
}
