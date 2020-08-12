import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/message_bar/message_bar.dart';
import 'package:flutter_chat/src/models/message/message.dart';
import 'package:flutter_chat/src/models/message/photo_message.dart';
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
        assert(currentUser != null),
        super(MessageBarInitial()) {
    _isTyping = false;
  }
  ChatService chatService;
  String groupId;
  User currentUser;
  UploadFileBloc uploadFileBloc;
  bool _isTyping;
  StreamSubscription _storeFileProgress;

  @override
  Future<void> close() async {
    _storeFileProgress?.cancel();
    super.close();
  }

  @override
  Stream<MessageBarState> mapEventToState(
    MessageBarEvent event,
  ) async* {
    try {
      if (event is StoreImageEvent) {
        final String filename =
            '${currentUser.id}_${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
        _storeFileProgress = chatService
            .storeFileStream(filename, event.imageFile)
            .listen((fileUpload) {
          if (fileUpload.downloadUrl == null) {
            uploadFileBloc.add(UploadFileEvent(fileUpload.progress));
          } else {
            final Message message = PhotoMessage(
              fileUpload.downloadUrl,
              currentUser.id,
            );
            add(SendMessageEvent(message));
            uploadFileBloc.add(const UploadFileEvent(-1));
          }
        });
      }
      if (event is SendMessageEvent) {
        chatService.sendMessage(groupId, event.message);
      }
      if (event is IsTyping) {
        if (event.isTyping) {
          if (!_isTyping) {
            chatService.isTyping(groupId, isTyping: event.isTyping);
          }
        } else {
          _isTyping = false;
          chatService.isTyping(groupId, isTyping: event.isTyping);
        }
      }
    } catch (e) {
      yield MessageBarError();
    }
  }
}
