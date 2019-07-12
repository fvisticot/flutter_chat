import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class HeroPhotoViewWrapper extends StatelessWidget {
  const HeroPhotoViewWrapper({
    @required this.heroTag,
    this.imageProvider,
    this.loadingChild,
    this.backgroundDecoration,
  });

  final String heroTag;
  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Decoration backgroundDecoration;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
            imageProvider: imageProvider,
            loadingChild: loadingChild,
            backgroundDecoration: backgroundDecoration,
            minScale: 0.5,
            maxScale: 2.0,
            heroTag: heroTag,
            transitionOnUserGestures: true,
            onTapUp: (context, details, controller) {
              Navigator.of(context).pop();
            }));
  }
}
