import 'package:equatable/equatable.dart';

class UploadFileState extends Equatable {
  UploadFileState([List props = const []]) : super(props);
}

class UploadFileProgress extends UploadFileState {
  final double progress;

  UploadFileProgress(this.progress)
      : assert(progress != null),
        super([progress]);

  @override
  String toString() => 'UploadFileProgress $progress';
}

class UploadFileInitial extends UploadFileState {
  @override
  String toString() => 'UploadFileInitial';
}
