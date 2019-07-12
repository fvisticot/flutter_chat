import 'package:equatable/equatable.dart';

class UploadFileState extends Equatable {
  UploadFileState([List props = const []]) : super(props);
}

class UploadFileProgress extends UploadFileState {
  UploadFileProgress(this.progress)
      : assert(progress != null),
        super([progress]);
  final double progress;

  @override
  String toString() => 'UploadFileProgress $progress';
}

class UploadFileInitial extends UploadFileState {
  @override
  String toString() => 'UploadFileInitial';
}
