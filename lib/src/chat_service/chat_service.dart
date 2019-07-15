import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat/src/models/models.dart';

abstract class ChatService {
  Future<User> initChat();

  Future<void> setPresence({@required bool presence});

  Future<Group> getGroupInfo(String groupId);

  Future<List<String>> getGroupUsers(String groupId);

  Future<User> getUserFromId(String userId);

  Stream<List<Message>> streamOfMessages(String groupId);

  Stream<bool> userPresence(String userId);

  void sendMessage(String groupId, Message message);

  StorageUploadTask storeFileTask(String filename, File file);

  Stream<List<String>> typingUsers(String groupId, User currentUser);

  Future<void> isTyping(String groupId, User writer, {@required bool isTyping});

  Future<Map<String, String>> searchUsersByName(String name);

  Future<String> getDuoGroupId(String currentUserId, String userId);

  Future<String> createDuoGroup(String currentUserId, String userId);

  Stream<Map<String, dynamic>> streamOfUserDiscussions(String currentUserId);
}
