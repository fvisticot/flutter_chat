import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat/src/models/models.dart';

abstract class DataRepository {
  Future<User> initChat(String userName);

  Future<Group> getGroupInfo(String groupId);

  Future<List<String>> getGroupUsers(String groupId);

  Future<User> getUserFromId(String userId);

  Stream<List<Message>> streamOfMessages(String groupId);

  Stream<bool> userPresence(userId);

  sendMessage(String groupId, Message message);

  StorageUploadTask storeFileTask(String filename, File file);

  Stream<List<String>> typingUsers(String groupId, User currentUser);

  Future<void> isTyping(String groupId, User writer, bool isTyping);
}