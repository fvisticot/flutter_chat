import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';

//typedef onSelectedSticker = void Function(Sticker sticker);
//typedef onSelectedAsset = void Function(AssetType type, Uint8List data);
typedef onSendButtonClicked = void Function(String text);
typedef onTyping = void Function(bool isTyping);

class ChatBar extends StatefulWidget {
  final Function onSendButtonClicked;
  final Function onSelectedSticker;
  final Function onSelectedAsset;
  final Function onLocationShared;
  final Function onTyping;
  final String message;

  ChatBar(
      {this.onSendButtonClicked,
      this.onSelectedSticker,
      this.onSelectedAsset,
      this.onLocationShared,
      this.onTyping,
      this.message});

  @override
  _ChatBarState createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> with SingleTickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isShowSticker = false;
  bool _isShowAsset = false;
  bool _isShowSendButton = false;

  List<Sticker> _stickers = [];
  Timer _typingTimer;

  @override
  void initState() {
    _textEditingController.addListener(() {
      if (_textEditingController.text.length > 0) {
        _typingEvents();

        if (!_isShowSendButton) {
          setState(() {
            _isShowSendButton = true;
          });
        }
      } else {
        setState(() {
          _isShowSendButton = false;
        });
      }
    });

    _focusNode.addListener(onFocusChange);
    _initStickers();
    super.initState();
  }

  _typingEvents() {
    if (widget.onTyping != null) {
      widget.onTyping(true);
    }

    if (_typingTimer != null && _typingTimer.isActive) {
      _typingTimer.cancel();
    }
    _typingTimer = Timer(Duration(seconds: 5), () {
      if (widget.onTyping != null) {
        widget.onTyping(false);
      }
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  _initStickers() async {
    _stickers = await StickersStore.fromStandart().stickers();
    print('${_stickers.length} stickers loaded');
    setState(() {});
  }

  void onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        _isShowSticker = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.blue;

    return SafeArea(
      child: Container(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          widget.message != null ? _buildInfo() : Container(),
          _isShowSticker ? _buildStickerSelection() : Container(),
          Container(
            decoration: new BoxDecoration(color: Colors.white.withOpacity(0.5)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: new EdgeInsets.symmetric(horizontal: 1.0),
                        child: new IconButton(
                          icon: new Icon(Icons.location_on),
                          onPressed: () {
                            if (widget.onLocationShared != null) {
                              widget.onLocationShared();
                            }
                          },
                          color: primaryColor,
                        ),
                      ),
                      // Button send image
                      Container(
                        margin: new EdgeInsets.symmetric(horizontal: 1.0),
                        child: new IconButton(
                          icon: new Icon(Icons.image),
                          onPressed: () {
                            _isShowSticker = false;
                            _isShowAsset = !_isShowAsset;
                            setState(() {});
                          },
                          color: primaryColor,
                        ),
                      ),
                      Container(
                        margin: new EdgeInsets.symmetric(horizontal: 1.0),
                        child: new IconButton(
                          icon: new Icon(Icons.face),
                          onPressed: () {
                            _isShowAsset = false;
                            _isShowSticker = !_isShowSticker;
                            setState(() {});
                          },
                          color: primaryColor,
                        ),
                      ),

                      // Edit text
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.3))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              autocorrect: true,
                              maxLines: null,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                              ),
                              controller: _textEditingController,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Type your message...',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              focusNode: _focusNode,
                            ),
                          ),
                        ),
                      ),

                      // Button send message
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: _isShowSendButton
                              ? () {
                                  if (widget.onSendButtonClicked != null) {
                                    widget.onSendButtonClicked(
                                        _textEditingController.text);
                                  }
                                  _textEditingController.clear();
                                }
                              : null,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  )),
            ),
            width: double.infinity,
          ),
          _isShowAsset ? _buildAssetSelection() : Container(),
        ]),
      ),
    );
  }

  Widget _buildInfo() {
    return Container(
        child: Text(
      widget.message,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 10, color: Colors.blueGrey),
    ));
  }

  _buildStickerSelection() {
    return StickerSelection(_stickers, onSelectedSticker: (sticker) {
      if (widget.onSelectedSticker != null) {
        _isShowSticker = false;
        setState(() {});
        widget.onSelectedSticker(sticker);
      }
    });
  }

  Widget _buildAssetSelection() {
    return AssetSelection(
      onSelectedAsset: (AssetType type, Uint8List data) {
        if (widget.onSelectedAsset != null) {
          widget.onSelectedAsset(type, data);
          setState(() {
            _isShowAsset = false;
          });
        }
      },
    );
  }
}
