import 'dart:async';
import 'package:bloc/bloc.dart';
import 'upload_file.dart';

class UploadFileBloc extends Bloc<UploadFileEvent, UploadFileState> {
  UploadFileBloc() : super(UploadFileInitial());

  @override
  Stream<UploadFileState> mapEventToState(UploadFileEvent event) async* {
    if (event is UploadFileEvent) {
      if (event.progress < 0) {
        yield UploadFileInitial();
      }
      else {
        yield UploadFileProgress(event.progress);
      }
    }
  }
}