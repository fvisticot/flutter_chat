import 'dart:async';
import 'dart:io';

import 'package:flutter_chat/src/models/file_upload.dart';
import 'package:flutter_chat/src/models/group.dart';
import 'package:flutter_chat/src/models/message/message.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:meta/meta.dart';

abstract class ChatService {
  Future<void> initPresence();

  Future<void> setPresence({@required bool presence});

  Future<void> setDevicePushToken();

  Stream<bool> userPresenceStream(String userId);

  Stream<bool> hasUnreadMessageStream();

  Future<Group> getGroupInfo(String groupId);

  Future<List<String>> getGroupUsers(String groupId);

  Future<User> getChatUser();

  Stream<List<Message>> streamOfMessages(String groupId);

  Future<void> sendMessage(String groupId, Message message);

  Stream<FileUpload> storeFileStream(String filename, File file);

  Future<Stream<List<String>>> typingUsers(String groupId);

  Future<void> isTyping(String groupId, {@required bool isTyping});

  Future<Map<String, String>> searchUsersByName(String name);

  Future<String> getDuoGroupId(String currentUserId, String userId);

  Future<String> createDuoGroup(String currentUserId, String userId);

  Future<Stream<Map<String, dynamic>>> streamOfUserDiscussions();
}
