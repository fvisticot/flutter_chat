import 'package:equatable/equatable.dart';

abstract class UploadFileState extends Equatable {
  const UploadFileState();
}

class UploadFileProgress extends UploadFileState {
  const UploadFileProgress(this.progress) : assert(progress != null);
  final double progress;

  @override
  String toString() => 'UploadFileProgress{progress: $progress}';
  @override
  List<Object> get props => [progress];
}

class UploadFileInitial extends UploadFileState {
  @override
  String toString() => 'UploadFileInitial';
  @override
  List<Object> get props => [];
}
