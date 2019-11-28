import 'package:flutter_chat/src/upload_file/upload_file_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UploadFileEvent with null parameter should throw assertion', () {
    expect(
        () => UploadFileEvent(null), throwsA(isInstanceOf<AssertionError>()));
  });

  test(
      'UploadFileEvent toString method should return : "UploadFileEvent [progress]"',
      () {
    const double progress = 10.2;
    const UploadFileEvent uploadFileEvent = UploadFileEvent(progress);
    expect(uploadFileEvent.toString(), 'UploadFileEvent $progress');
  });
}
