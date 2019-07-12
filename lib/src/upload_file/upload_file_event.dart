import 'package:equatable/equatable.dart';

class UploadFileEvent extends Equatable {
  UploadFileEvent(this.progress)
      : assert(progress != null),
        super([progress]);
  final double progress;

  @override
  String toString() => 'UploadFileEvent $progress';
}
