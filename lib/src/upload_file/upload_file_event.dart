import 'package:equatable/equatable.dart';

class UploadFileEvent extends Equatable {
  final double progress;

  UploadFileEvent(this.progress)
      :assert (progress!=null),
        super([progress]);

  @override
  String toString() => 'UploadFileEvent $progress';
}