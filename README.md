# flutter_chat

Embed a chat in your app (using firebase).

## Getting Started

To use flutter_chat you need a firebase account.

## Set user presence

You need to listen when the app is in foreground to set the user presence.

```
class _YourStatefullWidgetState extends State<YourStatefullWidget> with WidgetsBindingObserver {
 ChatFirebaseRepository firebaseRepository;

 @override
 void initState() {
   WidgetsBinding.instance.addObserver(this);
   firebaseRepository = ChatFirebaseRepository();
   ...
 }

 @override
 void dispose() {
   WidgetsBinding.instance.removeObserver(this);
   ...
 }

 @override
 void didChangeAppLifecycleState(AppLifecycleState state) {
   if (state == AppLifecycleState.resumed) {
     chatRepository.setPresence(true);
   } else {
     chatRepository.setPresence(false);
   }
 }

}
```
