import 'dart:io';

import 'package:file_picker/file_picker.dart';

class PickerFunctions {
  Future<File?> image() async {
    final FilePickerResult? _file = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (_file == null) return null;
    return File(_file.paths.first!);
  }
}
