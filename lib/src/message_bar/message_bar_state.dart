import 'package:equatable/equatable.dart';

abstract class MessageBarState extends Equatable {
  const MessageBarState();
}

class MessageBarInitial extends MessageBarState {
  @override
  String toString() => 'MessagebarInitial';
  @override
  List<Object> get props => [];
}

class MessageBarSuccess extends MessageBarState {
  @override
  String toString() => 'MessageBarSuccess';
  @override
  List<Object> get props => [];
}

class MessageBarError extends MessageBarState {
  @override
  String toString() => 'MessageBarError';
  @override
  List<Object> get props => [];
}
