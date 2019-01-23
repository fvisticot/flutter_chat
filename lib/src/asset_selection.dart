import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart' hide AssetType;
import 'package:photo_manager/photo_manager.dart' as Pm show AssetType;

typedef onSelectedAsset = void Function(AssetType type, Uint8List data);

enum AssetType { photo, video, other }

class AssetSelection extends StatefulWidget {
  final Function onSelectedAsset;

  AssetSelection({this.onSelectedAsset});

  @override
  State<StatefulWidget> createState() => _AssetSelectionState();
}

class _AssetSelectionState extends State<AssetSelection> {
  List<AssetEntity> _assets;

  @override
  void initState() {
    _initPhotoLibrary();
  }

  _initPhotoLibrary() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      List<AssetPathEntity> list = await PhotoManager.getAssetPathList();
      List<AssetPathEntity> allPhotoPath = list
          .where((assetEntity) => assetEntity.name == 'All Photos')
          .toList();

      final start = DateTime.now();
      List<AssetEntity> allAssets = await allPhotoPath.first.assetList;
      print('==>${DateTime.now().difference(start)}');
      _assets = allAssets
          .sublist(allAssets.length - 5)
          .where((asset) => asset.type == Pm.AssetType.image)
          .toList();
      print('==>${DateTime.now().difference(start)}');
      setState(() {});
    } else {
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_assets == null || _assets.length == 0) {
      return Container(
        height: 150,
        decoration: BoxDecoration(color: Colors.white),
      );
    }
    return Container(
      height: 150,
      decoration: BoxDecoration(color: Colors.white),
      child: ListView.separated(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: _assets.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 2.0,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder<Widget>(
              future: _buildImageFromAsset(_assets[index]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data;
                } else {
                  return Container();
                }
              });
        },
      ),
    );
  }

  AssetType _assetTypeFromAsset(AssetEntity entity) {
    switch (entity.type) {
      case Pm.AssetType.image:
        return AssetType.photo;
        break;
      case Pm.AssetType.video:
        return AssetType.video;
        break;
      case Pm.AssetType.other:
        return AssetType.other;
    }
  }

  Future<Widget> _buildImageFromAsset(AssetEntity assetEntity) async {
    var start = DateTime.now();
    Uint8List thumbData = await assetEntity.thumbDataWithSize(150, 150);
    print('${DateTime.now().difference(start)}');
    return GestureDetector(
      onTap: () async {
        final data = await assetEntity.thumbDataWithSize(600, 600);
        if (widget.onSelectedAsset != null) {
          final assetType = _assetTypeFromAsset(assetEntity);
          if (widget.onSelectedAsset != null) {
            widget.onSelectedAsset(assetType, data);
          }
        }
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.memory(
          thumbData,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
