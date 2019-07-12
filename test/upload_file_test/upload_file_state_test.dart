import 'package:flutter_chat/src/upload_file/upload_file_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UploadFileProgress with null parameter should throw assertion', () {
    expect(() => UploadFileProgress(null),
        throwsA(isInstanceOf<AssertionError>()));
  });

  test(
      'UploadFileProgress toString method should return : "UploadFileProgress [progress]"',
      () {
    const double progress = 10.2;
    final UploadFileProgress uploadFileProgress = UploadFileProgress(progress);
    expect(uploadFileProgress.toString(), 'UploadFileProgress $progress');
  });

  test('UploadFileInitial toString method should return : "UploadFileInitial"',
      () {
    final UploadFileInitial uploadFileInitial = UploadFileInitial();
    expect(uploadFileInitial.toString(), 'UploadFileInitial');
  });
}
