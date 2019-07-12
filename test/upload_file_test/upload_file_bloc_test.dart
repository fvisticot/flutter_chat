import 'package:flutter_chat/src/upload_file/upload_file.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  UploadFileBloc uploadFileBloc;

  setUp(() {
    uploadFileBloc = UploadFileBloc();
  });

  test('UploadFileBloc initial state should be UploadFileInitial', () {
    expect(uploadFileBloc.initialState, UploadFileInitial());
  });

  test('UplaodFileBloc dispose should not emit new states', () {
    expectLater(
      uploadFileBloc.state,
      emitsInOrder([]),
    );
    uploadFileBloc.dispose();
  });

  test(
      'UploadFileBloc should emits [UploadFileInitial, UploadFileProgress] when UploadFileEvent is dispatched',
      () {
    expectLater(
      uploadFileBloc.state,
      emitsInOrder([UploadFileInitial(), UploadFileProgress(10.2)]),
    );
    uploadFileBloc.dispatch(UploadFileEvent(10.2));
  });

  test(
      'UploadFileBloc should emits [UploadFileInitial, UploadFileProgress, UploadFileInitial] when UploadFileEvent and then UploadFileEvent with progress < 0 is dispatched',
      () {
    expectLater(
      uploadFileBloc.state,
      emitsInOrder(
          [UploadFileInitial(), UploadFileProgress(10.2), UploadFileInitial()]),
    );
    uploadFileBloc.dispatch(UploadFileEvent(10.2));
    uploadFileBloc.dispatch(UploadFileEvent(-1));
  });
}
