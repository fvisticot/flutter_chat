import 'dart:io';

import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat/flutter_chat.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';

enum MessageType { text, audio, photo, video, file, sticker, unknown }

abstract class Message {
  DateTime timestamp;
  MessageType type;
  String id;
  String userId;
  String userName;

  Message({this.userId, this.userName, this.timestamp, this.id}) {
    if (this.timestamp == null) {
      this.timestamp = DateTime.now();
    }
  }

  Map<String, dynamic> toJson();
}

class TextMessage extends Message {
  final String text;

  TextMessage(this.text,
      {String userId, String userName, DateTime timestamp, String id})
      : super(
            userId: userId, userName: userName, timestamp: timestamp, id: id) {
    type = MessageType.text;
  }

  factory TextMessage.fromMap(Map map) {
    return TextMessage(
      map['text'],
      id: map['id'],
      userId: map['userId'],
      userName: map['userName'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'id': id,
        'type': 'text',
        'text': text,
        'timestamp': timestamp.toIso8601String(),
      };

  @override
  String toString() {
    return 'TextMessage{timestamp: $timestamp, text: $text}';
  }
}

class StickerMessage extends Message {
  final Sticker sticker;

  StickerMessage(this.sticker,
      {String id, String userId, String userName, DateTime timestamp})
      : super(
            userId: userId, timestamp: timestamp, id: id, userName: userName) {
    type = MessageType.sticker;
  }

  factory StickerMessage.fromMap(Map map) {
    Sticker sticker = StickersStore.fromStandart().sticker(map['stickerId']);

    return StickerMessage(sticker,
        timestamp: DateTime.parse(map['timestamp']),
        id: map['id'],
        userId: map['userId'],
        userName: map['userName']);
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'type': 'sticker',
        'stickerId': sticker.id,
        'id': id,
        'timestamp': timestamp.toIso8601String(),
      };
}

class AssetMessage extends Message {
  final AssetType assetType;
  final String url;

  AssetMessage(this.assetType, this.url,
      {DateTime timestamp, String id, String userId, String userName})
      : super(timestamp: timestamp, userId: userId, userName: userName) {
    switch (assetType) {
      case AssetType.video:
        type = MessageType.video;
        break;
      case AssetType.photo:
        type = MessageType.photo;
        break;
      default:
        break;
    }
  }

  factory AssetMessage.fromMap(Map map) {
    return AssetMessage(AssetType.photo, map['url'],
        timestamp: DateTime.parse(map['timestamp']),
        id: map['id'],
        userId: map['userId'],
        userName: map['userName']);
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'id': id,
        'type': 'photo',
        'timestamp': timestamp.toIso8601String(),
        'url': url,
      };
}

class LocationMessage extends Message {
  double longitude;
  double latitude;

  LocationMessage(this.longitude, this.latitude,
      {String id, DateTime timestamp, String userId, String userName})
      : super(timestamp: timestamp, id: id, userId: userId, userName: userName);

  factory LocationMessage.fromMap(Map map) {
    return LocationMessage(map['longitude'], map['latitude'],
        timestamp: DateTime.parse(map['timestamp']),
        id: map['id'],
        userId: map['userId'],
        userName: map['userName']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'id': id,
        'type': 'location',
        'longitude': longitude,
        'latitude': latitude,
        'timestamp': timestamp.toIso8601String(),
      };
}

class Chat {
  final Logger _log = new Logger('Chat');
  static bool _initialized = false;
  FirebaseDatabase database;
  User user;
  static final Chat _singleton = Chat._internal();

  Chat._internal() {}

  factory Chat() {
    return _singleton;
  }

  Future<void> init(FirebaseDatabase database, {User user}) async {
    initializeDateFormatting("fr_FR", null);
    this.database = database;
    final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    if (firebaseUser == null) {
      throw ChatException('User not authenticated on Firebase.');
    }

    final userDb = await userById(firebaseUser.uid);
    if (userDb == null) {
      if (user == null || user.firstName == null || user.lastName == null) {
        throw ChatException(
            'User info must be provided (firstName, lastName) to create the user on Chat DB.');
      }
      user.id = firebaseUser.uid;
      _log.finest('User not present in DB, creating user (${user}.');
      await _createUser(user);
    } else {
      user.id = firebaseUser.uid;
      _log.finest('User already present in DB.');
    }
    this.user = user;
    _initPresence();
  }

  _initPresence() {
    DatabaseReference amOnline = database.reference().child('.info/connected');
    DatabaseReference userRef =
        database.reference().child('presences/${user.id}');
    amOnline.onValue.listen((event) {
      _log.fine('Presence changed: ${event}');
      userRef.onDisconnect().remove();
      userRef.set(true);
    });
  }

  Future<void> setPushNotificationToken(String token) {
    return database
        .reference()
        .child('users')
        .child(user.id)
        .update({'pushToken': token});
  }

  Future<void> _createUser(User user) {
    return database
        .reference()
        .child('users')
        .child(user.id)
        .set(user.toJson());
  }

  Future<void> createContacts(List<String> usersIds) {
    List<Future> futures = [];
    usersIds.forEach((userIdIt) {
      futures.add(database
          .reference()
          .child('users-contacts')
          .child(user.id)
          .child(userIdIt)
          .set({
        'userId': userIdIt,
        'createdAt': DateTime.now().toIso8601String()
      }));
    });

    return Future.wait(futures);
  }

  Future<void> removeContact(String userId) {
    return database
        .reference()
        .child('users-contacts')
        .child(user.id)
        .child(userId)
        .remove();
  }

  Future<List<Contact>> contacts() async {
    DataSnapshot snapshot = await database
        .reference()
        .child('users-contacts')
        .child(user.id)
        .once();
    final map = snapshot?.value;
    List<Contact> contacts = [];
    if (map != null) {
      map.forEach((key, value) {
        if (value != null) {
          Contact contact = Contact.fromMap(value);
          contacts.add(contact);
        }
      });
    }
    return contacts;
  }

  Future<List<Group>> userGroups() async {
    DataSnapshot snapshot = await database
        .reference()
        .child('users')
        .child(user.id)
        .child('groups')
        .once();
    final map = snapshot?.value;

    if (map != null) {
      List<Future<Group>> futures = [];
      map.forEach((key, value) async {
        if (value != null) {
          final groupId = value['groupId'];
          futures.add(this.group(groupId));
        }
      });
      List<Group> groups = await Future.wait(futures);

      print('GROUPS: ${groups}');
      return groups;
    }
  }

  Stream<List<User>> users(
      {List<String> exceptUsersIds = const [], Filter filter}) {
    Query query = database.reference().child('users').orderByChild('lastName');

    if (filter != null && filter.startWith != null) {
      query =
          query.startAt(filter.startWith).endAt(('${filter.startWith}\uf8ff'));
    }

    Stream<Event> userCompletedStream = query.onValue;

    final Stream<List<User>> stream = userCompletedStream.map((event) {
      final map = event.snapshot.value;
      List<User> users = [];
      map.forEach((key, value) {
        User user = User.fromMap(value);
        user.id = key;
        if (!exceptUsersIds.contains(user.id)) {
          users.add(user);
        }
      });
      return users;
    });

    return stream;
  }

  Future<User> userById(String userId) async {
    DataSnapshot snapshot =
        await database.reference().child('users').child(userId).once();
    Map map = snapshot.value;
    if (map != null) {
      User user = User.fromMap(map);
      return user;
    } else {
      return null;
    }
  }

  Future<Group> group(String id) async {
    DataSnapshot snapshot = await database
        .reference()
        .child('groups')
        .orderByKey()
        .equalTo(id)
        .limitToFirst(1)
        .once();
    if (snapshot.value == null) {
      return null;
    } else {
      Map map = snapshot.value;
      Group group;
      map.forEach((key, value) {
        group = Group.fromMap(value);
        group.id = key;
      });
      return group;
    }
  }

  Future<List<Group>> groups() async {
    DataSnapshot snapshot = await database.reference().child('groups').once();
    Map map = snapshot?.value;
    List<Group> groups = [];
    if (map != null) {
      map.forEach((key, value) {
        Group group = Group.fromMap(value);
        group.id = key;
        if (group != null) {
          groups.add(group);
        }
      });
    }
    return groups;
  }

  Future<List<User>> presences() async {
    DataSnapshot snapshot =
        await database.reference().child('presences').once();
    Map map = snapshot?.value;

    List<String> usersIds = [];
    if (map != null) {
      map.forEach((key, value) {
        usersIds.add(key);
      });
    }

    List<Future> futures = [];
    usersIds.forEach((userId) {
      futures.add(userById(userId));
    });
    final res = await Future.wait(futures);
    return res;
  }

  Stream<String> typingEvent(String groupId) {
    print('SubscribeTyping for group $groupId');

    Stream<Event> childAddedStream = database
        .reference()
        .child('groups')
        .child(groupId)
        .child('activity')
        .onChildAdded;

    Stream<Event> childRemovedStream = database
        .reference()
        .child('groups')
        .child(groupId)
        .child('activity')
        .onChildRemoved;

    return StreamGroup.merge([childAddedStream, childRemovedStream])
        .map((event) {
      print(
          'previousSiblingKey: ${event.previousSiblingKey} Value: ${event.snapshot.value}');
      if (event.previousSiblingKey == null) {
        return null;
      } else {
        return event.snapshot.value;
      }
    });
  }

  Future<void> typing(bool isTyping, String groupId) {
    if (!isTyping) {
      return database
          .reference()
          .child('groups')
          .child(groupId)
          .child('activity')
          .child(user.id)
          .child('isTyping')
          .remove();
    }
    return database
        .reference()
        .child('groups')
        .child(groupId)
        .child('activity')
        .child(user.id)
        .update({'isTyping': true});
  }

  sendMessage(String groupId, Message message) async {
    message.userId = user.id;
    message.userName = user.firstName;
    database
        .reference()
        .child('groups-messages')
        .child(groupId)
        .push()
        .set(message.toJson());
  }

  Future<void> removeMessage(String groupId, String messageId) {
    print('Remove message: $groupId, $messageId');
    return database
        .reference()
        .child('groups-messages')
        .child(groupId)
        .child(messageId)
        .remove();
  }

  String groupForContact(String contactId) {
    String key;

    if (user.id.compareTo(contactId) < 0) {
      key = '${user.id}_$contactId';
    } else {
      key = '${contactId}_${user.id}';
    }
    return key;
  }

  /*
  messages(String groupId) async {
    DataSnapshot snapshot = await database
        .reference()
        .child('groups-messages')
        .child(groupId)
        .once();
    Map map = snapshot?.value;
    List<Message> messages = [];
    if (map != null) {
      map.forEach((key, value) {
        Message message = _decodeMessage(key, value);
        if (message != null) {
          messages.add(message);
        }
      });
    }
    return messages;
  }
  */

  Message _decodeMessage(String key, Map map) {
    String messageType = map['type'];
    if (messageType == null) {
      _log.severe('Bad message');
      return null;
    }

    Message message;
    switch (messageType) {
      case 'text':
        message = TextMessage.fromMap(map);
        break;
      case 'sticker':
        message = StickerMessage.fromMap(map);
        break;
      case 'photo':
        message = AssetMessage.fromMap(map);
        break;
      case 'location':
        message = LocationMessage.fromMap(map);
        break;
      default:
        break;
    }
    message.id = key;
    return message;
  }

  Stream<List<Message>> subscribeToMessages(String groupId) {
    print('==>SubscribeToMessage');
    List<Message> messages = [];
    Stream<Event> eventStream =
        database.reference().child('groups-messages').child(groupId).onValue;

    Stream<Event> eventAddedStream = database
        .reference()
        .child('groups-messages')
        .child(groupId)
        .onChildAdded;

    eventAddedStream.listen((event) {
      Message message =
          _decodeMessage(event.snapshot.key, event.snapshot.value);
      messages.add(message);
    });

    return eventStream.map((event) {
      return messages;
    });
  }

  Future<void> createGroup(String name, List<User> users, {File photo}) async {
    DatabaseReference ref = await database.reference().child('groups').push();
    String groupId = ref.key;
    await ref.set({
      'name': name,
      'createdAt': DateTime.now().toIso8601String(),
      'createdByUserId': user.id,
    });

    List<String> usersIds = users.map((user) => user.id).toList();
    usersIds.add(user.id);
    await _addUsersIdsToGroupId(usersIds, groupId);

    await _addGroupIdToUsersIds(groupId, usersIds);

    return;
  }

  Future<void> _addGroupIdToUsersIds(
      String groupId, List<String> usersIds) async {
    usersIds.forEach((userId) async {
      DatabaseReference ref =
          await database.reference().child('users/${userId}/groups').push();
      ref.set({
        'groupId': groupId,
        'createdAt': DateTime.now().toIso8601String(),
      });
    });
  }

  Future<void> _addUsersIdsToGroupId(
      List<String> usersIds, String groupId) async {
    List<Future> futures = [];
    usersIds.forEach((userId) {
      futures.add(database
          .reference()
          .child('groups-users')
          .child(groupId)
          .push()
          .set(
              {'userId': userId, 'addedAt': DateTime.now().toIso8601String()}));
    });
    await Future.wait(futures);
  }
}

class Filter {
  final String startWith;
  final int maxResults;

  Filter({this.startWith, this.maxResults = 10});
}

class ChatException implements Exception {
  String cause;
  ChatException(this.cause);

  @override
  String toString() {
    return 'ChatException{cause: $cause}';
  }
}
