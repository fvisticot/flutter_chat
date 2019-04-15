import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/upload_file/upload_file.dart';
import 'message_bar.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';
import 'package:flutter_chat/src/models/message.dart';
import 'package:image_picker/image_picker.dart';

class MessageBar extends StatefulWidget {
  final FirebaseRepository firebaseRepository;
  final String groupId;
  final User currentUser;
  final UploadFileBloc uploadFileBloc;

  MessageBar(this.firebaseRepository, this.groupId, this.currentUser, this.uploadFileBloc)
  : assert(firebaseRepository != null),
        assert(groupId!= null),
        assert(currentUser!= null);

  @override
  _MessageBarState createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  MessageBarBloc _messageBarBloc;
  TextEditingController _textMessageController;

  @override
  void initState() {
    _messageBarBloc = MessageBarBloc(widget.firebaseRepository, widget.groupId, widget.currentUser, widget.uploadFileBloc);
    _textMessageController = TextEditingController();
    _textMessageController.addListener(_isTyping);
    super.initState();
  }

  @override
  void dispose() {
    _textMessageController.dispose();
    super.dispose();
  }

  _isTyping() {
      _messageBarBloc.dispatch(IsTyping((_textMessageController.text.length > 0)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBarEvent, MessageBarState>(
        bloc: _messageBarBloc,
        builder: (context, messageBarState) {
          if (messageBarState is MessageBarInitial) {
            return Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    onPressed:() async {
                      File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
                        if (imageFile != null) {
                          _messageBarBloc.dispatch(StoreImageEvent(imageFile));
                        }
                      },
                    icon: Icon(Icons.photo_camera),
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.3))),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      autocorrect: true,
                      maxLines: null,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                      controller: _textMessageController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      //focusNode: _focusNode,
                    ),
                  ),
                ),
                // Button send message
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    onPressed:() {
                      if (_textMessageController.text.length > 0) {
                        Message message = TextMessage(_textMessageController.text, widget.currentUser.id, widget.currentUser.userName);
                        _messageBarBloc.dispatch(SendMessageEvent(message));
                        _textMessageController.clear();
                      }
                      },
                    icon: Icon(Icons.send),
                    color: Colors.blue,
                  ),
                ),
              ],
            );
          }
        }
    );
  }
}

