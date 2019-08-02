import 'package:flutter/material.dart';

class Styles {
  Styles._();
  static const LinearGradient gradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      Color.fromRGBO(77, 165, 156, 1),
      Color.fromRGBO(118, 197, 191, 1),
    ],
  );
  static const Color mainColor = Color.fromRGBO(49, 181, 171, 1);
  static const Color grey = Color.fromRGBO(140, 140, 140, 1);
  static final Color otherMessageBackgroundColor = Colors.black12;
  static const TextStyle otherMessagetext =
      TextStyle(color: Colors.black, fontSize: 14);
  static const TextStyle myMessagetext =
      TextStyle(color: Colors.white, fontSize: 14);

  static const TextStyle userTileText = TextStyle(
    color: grey,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle discussionLastMessageText = TextStyle(
    color: Colors.black,
    fontSize: 13,
  );
}
