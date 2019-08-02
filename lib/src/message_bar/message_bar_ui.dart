import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/common/styles.dart';
import 'package:flutter_chat/src/message_bar/message_bar.dart';
import 'package:flutter_chat/src/models/message/message.dart';
import 'package:flutter_chat/src/models/message/text_message.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/upload_file/upload_file.dart';
import 'package:image_picker/image_picker.dart';

class MessageBar extends StatefulWidget {
  const MessageBar(
    this.chatService,
    this.groupId,
    this.currentUser,
    this.uploadFileBloc,
  )   : assert(chatService != null),
        assert(groupId != null),
        assert(currentUser != null);

  final ChatService chatService;
  final String groupId;
  final User currentUser;
  final UploadFileBloc uploadFileBloc;

  @override
  _MessageBarState createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  MessageBarBloc _messageBarBloc;
  TextEditingController _textMessageController;

  @override
  void initState() {
    _messageBarBloc = MessageBarBloc(
      widget.chatService,
      widget.groupId,
      widget.currentUser,
      widget.uploadFileBloc,
    );
    _textMessageController = TextEditingController();
    _textMessageController.addListener(_isTyping);
    super.initState();
  }

  @override
  void dispose() {
    _textMessageController.dispose();
    super.dispose();
  }

  void _isTyping() {
    if (_textMessageController.text.length <= 1) {
      _messageBarBloc
          .dispatch(IsTyping(isTyping: _textMessageController.text.isNotEmpty));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBarBloc, MessageBarState>(
        bloc: _messageBarBloc,
        builder: (context, messageBarState) {
          if (messageBarState is MessageBarInitial) {
            return Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                      onPressed: () async {
                        try {
                          final File imageFile = await ImagePicker.pickImage(
                            source: ImageSource.gallery,
                            maxWidth: 750,
                            maxHeight: 750,
                          );
                          if (imageFile != null) {
                            _messageBarBloc
                                .dispatch(StoreImageEvent(imageFile));
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      icon: Icon(Icons.photo_library),
                      color: Styles.mainColor),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () async {
                      try {
                        final File imageFile = await ImagePicker.pickImage(
                          source: ImageSource.camera,
                          maxWidth: 750,
                          maxHeight: 750,
                        );
                        if (imageFile != null) {
                          _messageBarBloc.dispatch(StoreImageEvent(imageFile));
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    icon: Icon(Icons.photo_camera),
                    color: Styles.mainColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.3))),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          reverse: true,
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            autocorrect: true,
                            maxLines: null,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            controller: _textMessageController,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Message...',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            //focusNode: _focusNode,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Button send message
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    onPressed: () {
                      if (_textMessageController.text.isNotEmpty) {
                        final Message message = TextMessage(
                            _textMessageController.text, widget.currentUser.id);
                        _messageBarBloc.dispatch(SendMessageEvent(message));
                        _textMessageController.clear();
                      }
                    },
                    icon: Icon(Icons.send),
                    color: Styles.mainColor,
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: const Text('Error append'),
            );
          }
        });
  }
}
