import 'package:flutter/widgets.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';

/// A widget that indicates whether the user is connected to the chat or not
/// by listening the app state
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
  @override
  void initState() {
    super.initState();
    widget.chatService.initPresence();
    WidgetsBinding.instance.addObserver(this);
  }

  /// Set user presence when app is in foreground
  /// Unset user presence when app is in background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      widget.chatService.setPresence(presence: true);
    } else {
      widget.chatService.setPresence(presence: false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
