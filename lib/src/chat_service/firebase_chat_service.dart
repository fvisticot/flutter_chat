import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/models/file_upload.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat/src/models/models.dart';

class FirebaseChatService implements ChatService {
  FirebaseChatService(this.firebaseDatabase) : assert(firebaseDatabase != null);
  final FirebaseDatabase firebaseDatabase;

  Future<FirebaseUser> _getConnectedUser() async {
    final FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser == null) {
      throw Exception('User not authenticated on Firebase.');
    }
    return firebaseUser;
  }

  /// Returns `User` in chat
  /// Throw `Exception` if user doesn't exists
  @override
  Future<User> getChatUser() async {
    final FirebaseUser firebaseUser = await _getConnectedUser();
    final DataSnapshot userSnapshot = await firebaseDatabase
        .reference()
        .child('users/${firebaseUser.uid}')
        .once();
    final Map map = userSnapshot.value;
    if (map != null) {
      map['id'] = userSnapshot.key;
      final User user = User.fromMap(map);
      return user;
    } else {
      throw Exception('User doesn\'t exists in DB');
    }
  }

  /// Initialize user presence
  /// remove presence when user is disconnected from db
  @override
  Future<void> initPresence() async {
    final FirebaseUser firebaseUser = await _getConnectedUser();
    final DatabaseReference amOnline =
        firebaseDatabase.reference().child('.info/connected');
    final DatabaseReference userRef =
        firebaseDatabase.reference().child('presences/${firebaseUser.uid}');
    amOnline.onValue.listen((event) {
      print('Presence changed: ${event.snapshot.value}');
      userRef.onDisconnect().remove();
      userRef.set(true);
    });
  }

  /// Set user presence
  /// if [presence] is`true` user is connected to the chat
  /// if `false` user is disconnected from the chat
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

  /// Get `Group` info of [groupId]
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
      throw Exception('Unknown group $groupId');
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

  /// Stream that represents [groupId] 50 last messages
  /// Returns a `List<Message>` ordered by message key
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
      throw Exception('Can not get messages from $groupId : $e');
    }
  }

  /// Stream that represents [userId] presence
  /// Values are `true` when the user is connected to the chat
  /// `false` when the user is disconnected
  @override
  Stream<bool> userPresenceStream(String userId) {
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

  /// Stream that represents if user has unread message
  /// Values are `true` when the user has unread messages
  /// `false` when the user has read all messages
  @override
  Stream<bool> hasUnreadMessageStream() {
    // TODO(mattis): implement hasUnreadMessageStream
    return null;
  }

  /// Send [message] to [groupId]
  @override
  Future<void> sendMessage(String groupId, Message message) async {
    try {
      return firebaseDatabase
          .reference()
          .child('groups-messages')
          .child(groupId)
          .push()
          .update(message.toJson());
    } catch (e) {
      throw Exception('Error sending message $message to group $groupId : $e');
    }
  }

  /// Future Stream that represents the typing users in [groupId]
  /// The value in the stream is a `List<String>` that are the names of typing users
  /// Doesn't return our user name
  @override
  Future<Stream<List<String>>> typingUsers(String groupId) async {
    final FirebaseUser firebaseUser = await _getConnectedUser();
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
            if (firebaseUser.uid != activityKey) {
              userNames.add(activityValue);
            }
          });
        }
        return userNames;
      });
    } catch (e) {
      throw Exception('Error getting typing users in group $groupId : $e');
    }
  }

  /// Indicates if user [isTyping] in [groupId]
  @override
  Future<void> isTyping(String groupId, {@required bool isTyping}) async {
    final User chatUser = await getChatUser();
    final DatabaseReference activityRef =
        firebaseDatabase.reference().child('groups-activities').child(groupId);

    if (isTyping) {
      await activityRef.update({chatUser.id: chatUser.userName});
      activityRef.child(chatUser.id).onDisconnect().remove();
    } else {
      return activityRef.child(chatUser.id).remove();
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

  /// Future Stream that represents the the user's discussions
  ///
  /// The value in the stream is a `Map<String, dynamic>` representing the discussions of a user
  /// sorted by the `lastMsgTimestamp`
  @override
  Future<Stream<Map<String, dynamic>>> streamOfUserDiscussions() async {
    final FirebaseUser firebaseUser = await _getConnectedUser();
    try {
      return firebaseDatabase
          .reference()
          .child('users-groups')
          .child(firebaseUser.uid)
          .onValue
          .map((event) {
        final Map<String, dynamic> discussions = {};
        final Map<dynamic, dynamic> map = event.snapshot.value;
        if (map != null) {
          final List<dynamic> list = map.keys.toList()
            ..sort(
              (a, b) {
                return map[b]['lastMsgTimestamp']
                    .compareTo(map[a]['lastMsgTimestamp']);
              },
            );
          final LinkedHashMap sortedMap = LinkedHashMap.fromIterable(list,
              key: (k) => k, value: (k) => map[k]);
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
    } catch (e) {
      throw Exception('Can not get the users discussions : $e');
    }
  }

  /// Set the user's device token in database
  @override
  Future<void> setDevicePushToken() async {
    try {
      final FirebaseUser firebaseUser = await _getConnectedUser();
      final String pushToken = await FirebaseMessaging().getToken();
      print(pushToken);
      return firebaseDatabase
          .reference()
          .child('users-pushTokens')
          .update({'${firebaseUser.uid}': pushToken});
    } catch (e) {
      throw Exception('Can not set firebase push token : $e');
    }
  }

  /// Returns a Stream representing the file upload
  ///
  /// The value of the upload progress is [FileUpload.progress]
  /// if [FileUpload.downloadUrl] isn't null the upload is done
  @override
  Stream<FileUpload> storeFileStream(String filename, File file) {
    try {
      final StorageReference _storageReference =
          FirebaseStorage.instance.ref().child(filename);
      final StorageUploadTask _storageTask = _storageReference.putFile(file);
      final StreamController<FileUpload> controller = StreamController();
      _storageTask.events.listen((event) {
        final double progress = event.snapshot.bytesTransferred.toDouble() /
            event.snapshot.totalByteCount.toDouble();
        controller.add(FileUpload(progress: progress));
      });
      _storageTask.onComplete.then((snapshot) {
        snapshot.ref.getDownloadURL().then((url) {
          controller.add(FileUpload(progress: 100, downloadUrl: url));
        });
      });
      return controller.stream;
    } catch (e) {
      throw Exception('Can not store file $filename : $e');
    }
  }
}
