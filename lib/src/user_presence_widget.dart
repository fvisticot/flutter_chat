import 'package:flutter/widgets.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';

/// A widget that set user presence in the chat by taking care of app state
class ChatPresenceWidget extends StatefulWidget {
  const ChatPresenceWidget({
    Key key,
    @required this.chatService,
    this.child,
  })  : assert(chatService != null),
        super(key: key);

  final ChatService chatService;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  _ChatPresenceWidgetState createState() => _ChatPresenceWidgetState();
}

class _ChatPresenceWidgetState extends State<ChatPresenceWidget>
    with WidgetsBindingObserver {
  /// Set user presence when app is in foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      widget.chatService.setPresence(presence: true);
      print('resumed');
    } else {
      widget.chatService.setPresence(presence: false);
      print('background');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
