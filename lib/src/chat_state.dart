import 'package:meta/meta.dart';

class ChatState {
  final bool isLoading;
  final String error;

  const ChatState({
    @required this.isLoading,
    @required this.error,
  });

  factory ChatState.initial() {
    return ChatState(
      isLoading: false,
      error: '',
    );
  }

  factory ChatState.loading() {
    return ChatState(
      isLoading: true,
      error: '',
    );
  }

  factory ChatState.failure(String error) {
    return ChatState(
      isLoading: false,
      error: error,
    );
  }

  factory ChatState.success() {
    return ChatState(
      isLoading: false,
      error: '',
    );
  }
}
