import 'package:equatable/equatable.dart';

class UploadFileEvent extends Equatable {
  const UploadFileEvent(this.progress) : assert(progress != null);
  final double progress;

  @override
  String toString() => 'UploadFileEvent{progress: $progress}';
  @override
  List<Object> get props => [progress];
}
