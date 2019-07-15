import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/message_bar/message_bar.dart';
import 'package:flutter_chat/src/models/message/message.dart';
import 'package:flutter_chat/src/models/models.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/upload_file/upload_file.dart';

class MessageBarBloc extends Bloc<MessageBarEvent, MessageBarState> {
  MessageBarBloc(
    this.chatService,
    this.groupId,
    this.currentUser,
    this.uploadFileBloc,
  )   : assert(chatService != null),
        assert(groupId != null),
        assert(currentUser != null) {
    _isTyping = false;
  }
  ChatService chatService;
  String groupId;
  User currentUser;
  UploadFileBloc uploadFileBloc;
  bool _isTyping;

  @override
  MessageBarState get initialState => MessageBarInitial();

  @override
  Stream<MessageBarState> mapEventToState(
    MessageBarEvent event,
  ) async* {
    try {
      if (event is StoreImageEvent) {
        final String filename =
            '${currentUser.id}_${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
        final StorageUploadTask task =
            chatService.storeFileTask(filename, event.imageFile);
        task.events.listen((event) {
          final double progress = event.snapshot.bytesTransferred.toDouble() /
              event.snapshot.totalByteCount.toDouble();
          uploadFileBloc.dispatch(UploadFileEvent(progress));
        });
        task.onComplete.then((snapshot) {
          snapshot.ref.getDownloadURL().then((url) {
            final Message message = PhotoMessage(
              url,
              currentUser.id,
            );
            dispatch(SendMessageEvent(message));
            uploadFileBloc.dispatch(UploadFileEvent(-1));
          });
        });
      }
      if (event is SendMessageEvent) {
        chatService.sendMessage(groupId, event.message);
      }
      if (event is IsTyping) {
        if (event.isTyping) {
          if (!_isTyping) {
            chatService.isTyping(groupId, currentUser,
                isTyping: event.isTyping);
          }
        } else {
          _isTyping = false;
          chatService.isTyping(groupId, currentUser, isTyping: event.isTyping);
        }
      }
    } catch (e) {
      yield MessageBarError();
    }
  }
}
