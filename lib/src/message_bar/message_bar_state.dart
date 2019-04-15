import 'package:equatable/equatable.dart';

abstract class MessageBarState extends Equatable {
  MessageBarState([List props = const []]) : super(props);
}

class MessageBarInitial extends MessageBarState {
  @override
  String toString() => 'MessagebarInitial';
}

class MessageBarSuccess extends MessageBarState {
  @override
  String toString() => 'MessageBarSuccess';
}

class MessageBarError extends MessageBarState {
  @override
  String toString() => 'MessageBarError';
}