import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat/src/models/message.dart';
import 'package:flutter_chat/src/upload_file/upload_file.dart';
import 'message_bar.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';
import 'package:flutter_chat/src/models/user.dart';

class MessageBarBloc extends Bloc<MessageBarEvent, MessageBarState> {
  FirebaseRepository firebaseRepository;
  String groupId;
  User currentUser;
  UploadFileBloc uploadFileBloc;
  bool _isTyping;

  MessageBarBloc(this.firebaseRepository, this.groupId, this.currentUser, this.uploadFileBloc)
      : assert(firebaseRepository != null),
        assert(groupId != null),
        assert(currentUser != null) {
    _isTyping = false;
  }

  @override
  MessageBarState get initialState => MessageBarInitial();

  @override
  Stream<MessageBarState> mapEventToState(MessageBarEvent event,) async* {
    try {
      if (event is StoreImageEvent) {
        String filename = currentUser.id + "_" + DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
        StorageUploadTask task = firebaseRepository.storeFileTask(filename, event.imageFile);
        task.events.listen((event) {
          double progress = event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble();
          uploadFileBloc.dispatch(UploadFileEvent(progress));
        });
        task.onComplete.then((snapshot){
          snapshot.ref.getDownloadURL().then((url){
            Message message = PhotoMessage(url, currentUser.id, currentUser.userName);
            dispatch(SendMessageEvent(message));
            uploadFileBloc.dispatch(UploadFileEvent(-1.0));
          });
        });
      }
      if (event is SendMessageEvent) {
        await firebaseRepository.sendMessage(groupId, event.message);
      }
      if (event is IsTyping) {
        if (event.isTyping) {
          if (!_isTyping) {
            firebaseRepository.isTyping(groupId, currentUser, event.isTyping);
          }
        } else {
          _isTyping = false;
          firebaseRepository.isTyping(groupId, currentUser, event.isTyping);
        }
      }
    } catch (e) {
      yield MessageBarError();
    }
  }
}