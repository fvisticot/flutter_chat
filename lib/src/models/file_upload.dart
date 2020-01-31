import 'package:meta/meta.dart';

class FileUpload {
  FileUpload({@required this.progress, this.downloadUrl});

  final double progress;
  final String downloadUrl;
}
