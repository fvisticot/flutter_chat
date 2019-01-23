class StickersStore {
  static final StickersStore _singleton = new StickersStore._internal();
  static List<Sticker> _stickers = [];

  factory StickersStore() {
    return _singleton;
  }

  factory StickersStore.fromStandart() {
    _stickers
        .add(Sticker('1', name: 'mimi1', url: 'assets/stickers/mimi1.gif'));
    _stickers
        .add(Sticker('2', name: 'mimi2', url: 'assets/stickers/mimi2.gif'));
    _stickers
        .add(Sticker('3', name: 'mimi3', url: 'assets/stickers/mimi3.gif'));
    _stickers
        .add(Sticker('4', name: 'mimi4', url: 'assets/stickers/mimi4.gif'));
    _stickers
        .add(Sticker('5', name: 'mimi5', url: 'assets/stickers/mimi5.gif'));
    _stickers
        .add(Sticker('6', name: 'mimi6', url: 'assets/stickers/mimi6.gif'));
    _stickers
        .add(Sticker('7', name: 'mimi7', url: 'assets/stickers/mimi7.gif'));
    _stickers
        .add(Sticker('8', name: 'mimi8', url: 'assets/stickers/mimi8.gif'));
    _stickers
        .add(Sticker('9', name: 'mimi9', url: 'assets/stickers/mimi9.gif'));
    return _singleton;
  }

  StickersStore._internal() {}

  Future<List<Sticker>> stickers() async {
    return _stickers;
  }

  Sticker sticker(String id) {
    return _stickers.firstWhere((sticker) => sticker.id == id);
  }
}

enum StickerType { standart, custom }

class Sticker {
  String name;
  String id;
  String url;
  StickerType type;

  Sticker(this.id, {this.name, this.url, this.type = StickerType.standart});

  @override
  String toString() {
    return 'Sticker{name: $name, id: $id, url: $url, type: $type}';
  }
}
