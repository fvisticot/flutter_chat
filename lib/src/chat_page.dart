import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/flutter_chat.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class ChatPage extends StatefulWidget {
  final String groupId;

  ChatPage(this.groupId);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  final ChatBloc _chatBloc = ChatBloc();
  Chat _chat;
  ScrollController _scrollController;
  bool _isDuoChat = false;
  String _message;
  String _otherUserId;
  User _otherUser;
  StreamController<double> _uploadStreamController = StreamController();

  @override
  void initState() {
    _chat = Chat();

    final infos = widget.groupId.split('_');
    if (infos != null && infos.length == 2) {
      _isDuoChat = true;
      if (infos[0] == Chat().user.id) {
        _otherUserId = infos[1];
      } else {
        _otherUserId = infos[0];
      }
    }
    _scrollController = ScrollController();

    if (_isDuoChat) {
      _chat.typingEvent(_otherUserId).listen((event) {
        if (event == null) {
          _message = null;
        } else {
          if (event == widget.groupId) {
            _message = '${_otherUser.firstName} is typing...';
          }
        }
        setState(() {});
      });
    } else {}
  }

  @override
  void didUpdateWidget(ChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatEvent, ChatState>(
      bloc: _chatBloc,
      builder: (
        BuildContext context,
        ChatState settingsState,
      ) {
        return _buildPage(settingsState);
      },
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pop(context);
    return Future.value(false);
  }

  _buildPage(ChatState state) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        bottom: PreferredSize(
            child: StreamBuilder<double>(
                initialData: 0,
                stream: _uploadStreamController.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data == 0 ||
                      snapshot.data == 1.0) {
                    return Container();
                  } else {
                    return LinearProgressIndicator(
                      value: null,
                      backgroundColor: Colors.red,
                    );
                  }
                }),
            preferredSize: const Size(double.infinity, 6)),
        title: GestureDetector(
          child: _buildTitle(),
          onTap: () => print('Contacte:'),
        ),
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            _buildMessagesList(),

            ChatBar(
              message: _message,
              onTyping: (isTyping) => _chat.typing(isTyping, widget.groupId),
              onLocationShared: () => _shareLocation(),
              onSelectedAsset: (type, data) =>
                  _uploadAsset(type, data, _uploadStreamController.sink),
              onSelectedSticker: (sticker) =>
                  _chat.sendMessage(widget.groupId, StickerMessage(sticker)),
              onSendButtonClicked: (text) => _chat.sendMessage(
                    widget.groupId,
                    TextMessage(text),
                  ),
            )
            // Loading
            //_buildLoading()
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    if (_isDuoChat) {
      return FutureBuilder(
        future: Chat().userById(_otherUserId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            _otherUser = snapshot.data;
            return _avatarFromUser(_otherUser);
          }
        },
      );
    } else {
      return FutureBuilder(
          future: Chat().group(widget.groupId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              final group = snapshot.data;
              return Text('${group.name}');
            }
          });
    }
  }

  void _shareLocation() async {
    try {
      print('Share location');
      Location location = Location();
      final permission = await location.hasPermission();
      final currentLocation = await location.getLocation();
      _chat.sendMessage(
          widget.groupId,
          LocationMessage(
              currentLocation['longitude'], currentLocation['latitude']));
    } on PlatformException catch (e) {
      String error;
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }
      print('Error: $error');
      //location = null;
    }
  }

  void _uploadAsset(
      AssetType type, Uint8List data, Sink<double> uploadSink) async {
    final FirebaseApp app = FirebaseApp.instance;
    final FirebaseStorage storage = FirebaseStorage(
        app: app, storageBucket: 'gs://gamification-d5b83.appspot.com');

    print('Upload ${data.length} bytes');
    final StorageUploadTask uploadTask = storage
        .ref()
        .child('chat')
        .child('${DateTime.now().millisecondsSinceEpoch}')
        .putData(data);

    uploadTask.events.listen((event) {
      if (event.type == StorageTaskEventType.progress) {
        double percent = event.snapshot.bytesTransferred / data.length;
        print('Uploaded percentage: ${percent}');
        uploadSink.add(percent);
      }
      if (event.type == StorageTaskEventType.success) {
        uploadSink.add(1.0);
      }
      if (event.type == StorageTaskEventType.failure) {
        print('Error: ${event.toString()}');
      }
    });

    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    final uri = await snapshot.ref.getDownloadURL();

    _chat.sendMessage(widget.groupId, AssetMessage(type, uri));
  }

  _buildMessagesList() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Container(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Scrollbar(
              child: StreamBuilder<List<Message>>(
                stream: _chat.subscribeToMessages(widget.groupId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('No message');
                  } else {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(0,
                          duration: Duration(microseconds: 500),
                          curve: Curves.easeIn);
                    }
                    List<Message> messages = snapshot.data;
                    return ListView.separated(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      //shrinkWrap: true,
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      itemCount: messages.length + 1,
                      itemBuilder: (BuildContext context, int i) {
                        if (i == 0) {
                          return Container(
                            height: 60,
                          );
                        }
                        return _buildMessage(messages[messages.length - i]);
                      },
                      separatorBuilder: (context, i) {
                        Message prevMessage;
                        Message currentMessage;
                        Message nextMessage;
                        if (i == 0 || i == messages.length + 1) {
                          return Container();
                        }

                        print('I: ${i}  Length: ${messages.length}');

                        currentMessage = messages[(messages.length - i)];
                        print('CurrentMessage ${currentMessage}');

                        prevMessage = messages[messages.length - i - 1];

                        print('PrevMessage ${prevMessage}');
                        if (i > 1) {
                          nextMessage = messages[(messages.length - i + 1)];
                          print('Next message: ${nextMessage}');
                          final currentMessageDay =
                              currentMessage.timestamp.day;
                          final nextMessageDay = nextMessage.timestamp.day;
                          print(
                              'Current day: ${currentMessageDay}[${currentMessage.timestamp}], Next message day: ${nextMessageDay}[${nextMessage.timestamp}]');
                          if (currentMessageDay != nextMessageDay) {
                            return Container(
                              child: Text(
                                '${DateFormat.yMd('fr_FR').add_Hm().format(nextMessage.timestamp)}',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }
                        }

                        return Container();
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationMessage(LocationMessage message) {
    print('BuildLoc');
    return Container(
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        child: GoogleMap(
          options: GoogleMapOptions(
            myLocationEnabled: false,
            mapType: MapType.hybrid,
            zoomGesturesEnabled: false,
            rotateGesturesEnabled: false,
            scrollGesturesEnabled: false,
            tiltGesturesEnabled: false,
            cameraPosition: CameraPosition(
                target: LatLng(message.latitude, message.longitude),
                zoom: 18.0),
          ),
          onMapCreated: (mapController) {
            final markerOptions = MarkerOptions(
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(message.latitude, message.longitude));
            mapController.addMarker(markerOptions);
          },
        ),
      ),
    );
  }

  Widget _widgetFromMessage(Message message) {
    if (message is TextMessage) {
      return _buildTextMessageWidget(message);
      //return WidgetMessage(child: widget, message: message);
    } else if (message is StickerMessage) {
      return _buildStickerMessage(message);
    } else if (message is AssetMessage) {
      Widget widget = _buildAssetMessage(message);
      return ActionMessage(child: widget, message: message);
    } else if (message is LocationMessage) {
      Widget widget = _buildLocationMessage(message);
      return widget;
    }
  }

  Widget _buildTextMessageWidget(TextMessage message) {
    bool isMine = Chat().user.id == message.userId ? true : false;
    return Container(
      child: Text(
        message.text,
        overflow: TextOverflow.ellipsis,
        maxLines: 5,
      ),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: isMine ? Colors.blue : Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.grey.withOpacity(0.3))),
    );
  }

  Widget _buildMessage(Message message) {
    Widget messageWidget = _widgetFromMessage(message);

    bool isMine = Chat().user.id == message.userId ? true : false;
    return GestureDetector(
      onLongPress: () => _displayActionBar(message),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
        child: Row(
          mainAxisAlignment:
              isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            isMine || _isDuoChat ? Container() : _buildAvatar(message.userId),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: isMine
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        Utils.formatDate(message.timestamp),
                        style: TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                    ),
                    messageWidget,
                    //Container(
                    //child: Text(message.timestamp.toIso8601String()),
                    //)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _displayActionBar(Message message) {
    print('Display action bar to delete ${message}');
    _chat.removeMessage(widget.groupId, message.id);
  }

  Widget _avatarFromUser(User user) {
    CircleAvatar avatar;
    if (user.photoUrl == null) {
      final avatarBgColor = Utils.colorFromStr(user.firstName);
      avatar = CircleAvatar(
          child: Text(
              '${user.firstName.trim().toUpperCase()[0]}${user.lastName.trim().toUpperCase()[0]}'),
          foregroundColor: Colors.white,
          backgroundColor: avatarBgColor);
    } else {
      avatar = CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(user.photoUrl),
      );
    }
    return avatar;
  }

  _buildAvatar(String userId) {
    return FutureBuilder<User>(
      future: _chat.userById(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var user = snapshot.data;
        var avatar;
        if (user.photoUrl == null) {
          final avatarBgColor = Utils.colorFromStr(user.firstName);
          avatar = CircleAvatar(
              child: Text(
                  '${user.firstName.trim().toUpperCase()[0]}${user.lastName.trim().toUpperCase()[0]}'),
              foregroundColor: Colors.white,
              backgroundColor: avatarBgColor);
        } else {
          avatar = CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
          );
        }
        return avatar;
      },
    );
  }

  Widget _buildStickerMessage(StickerMessage message) {
    return Container(
      width: 150,
      child: Image.asset(message.sticker.url),
      padding: EdgeInsets.all(8),
    );
  }

  Widget _buildAssetMessage(AssetMessage message) {
    bool isMine = Chat().user.id == message.userId ? true : false;
    return Container(
      child: Padding(
        padding: isMine
            ? const EdgeInsets.only(left: 60)
            : const EdgeInsets.only(right: 60),
        child: CachedNetworkImage(
          imageUrl: message.url,
          fadeInDuration: Duration(milliseconds: 200),
          fit: BoxFit.fill,
          placeholder: CircularProgressIndicator(),
        ),
      ),
      padding: EdgeInsets.all(8),
    );
  }
}

class ActionMessage extends StatelessWidget {
  final Widget child;
  final Message message;

  ActionMessage({this.child, this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(child: child),
        Container(
            child: IconButton(
                icon: Icon(Icons.share), onPressed: () => print('Action!')))
      ],
    ));
  }

  _longPress() {
    print('Long press');
  }
}
