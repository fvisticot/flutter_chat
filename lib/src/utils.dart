import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';
import 'package:intl/intl.dart';

class Utils {
  static Color colorFromStr(String str) {
    var hash = 0;

    for (var i = 0; i < str.length; i++) {
      hash = str.codeUnitAt(i) + ((hash << 5) - hash);
    }

    double hue = (hash % 360).toDouble();

    Color color = HSLColor.fromAHSL(1.0, hue, 0.68, 0.5).toColor();

    //print("HUE($str), Color: $color, Hue: $hue");

    return color;
  }

  static String formatDate(DateTime date, {bool displaySeconds = false}) {
    if (displaySeconds) return DateFormat.yMd('fr_FR').add_jm().format(date);
    return DateFormat.Hm().format(date);
  }

  static CircleAvatar buildAvatar(User user) {
    if (user.photoUrl == null) {
      final avatarBgColor = Utils.colorFromStr(user.firstName);
      return CircleAvatar(
          child: Text(
              '${user.firstName.trim().toUpperCase()[0]}${user.lastName.trim().toUpperCase()[0]}'),
          foregroundColor: Colors.white,
          backgroundColor: avatarBgColor);
    } else {
      return CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(user.photoUrl),
      );
    }
  }
}
