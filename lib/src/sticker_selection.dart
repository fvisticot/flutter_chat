import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';

typedef onSelectedSticker = void Function(Sticker sticker);

class StickerSelection extends StatefulWidget {
  final List<Sticker> stickers;
  bool isDisplayed;
  StickerSelection(this.stickers,
      {this.isDisplayed = true, this.onSelectedSticker});
  Function onSelectedSticker;

  @override
  State createState() => _StickerSelectionState();
}

class _StickerSelectionState extends State<StickerSelection>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;
  ScrollController _scrollController =
      ScrollController(keepScrollOffset: true, initialScrollOffset: 0);
  bool _isZoom = false;

  @override
  void initState() {
    print('Scroll init listener');
    _scrollController.addListener(_scrollListener);

    /*
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 10000), vsync: this);

    _animation = Tween(begin: 0.0, end: _isZoom ? 100.0 : 60.0)
        .animate(_animationController)
          ..addListener(() {
            setState(() {
              // the state that has changed here is the animation object’s value
            });
          })
          ..addStatusListener((status) {
            print('New status: $status');
            if (status == AnimationStatus.completed) {
              _animationController.forward();
            }
            if (status == AnimationStatus.dismissed) {
              _animationController.reverse();
              setState(() {});
            }
          });
    _animationController.forward();
    */
    super.initState();
  }

  void _scrollListener() {
    if (!_isZoom) {
      _enterZoom();
    }
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    print('===> widget updated');
  }

  void _enterZoom() {
    if (_isZoom) {
      return;
    } else {
      setState(() {
        _isZoom = true;
      });
      print('Starting timer');
      Timer(Duration(seconds: 3), () {
        //_scrollController.addListener(_listener);
        _isZoom = false;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('REBUILDING sticker');
    return GestureDetector(
      onLongPress: () {
        print('Long pressed detected enting zoom.');
        _enterZoom();
      },
      child: Container(
        decoration: new BoxDecoration(color: Colors.white.withOpacity(0.5)),
        height: _isZoom ? 100 : 60, //_animation.value,
        width: double.infinity,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: ListView.separated(
            controller: _scrollController,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: widget.stickers.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 2.0,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              final sticker = widget.stickers[index];
              return GestureDetector(
                onTap: () {
                  if (widget.onSelectedSticker != null)
                    widget.onSelectedSticker(sticker);
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    sticker.url,
                    width: _isZoom ? 100 : 60,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
