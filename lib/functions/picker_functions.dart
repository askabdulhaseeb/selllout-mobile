import 'dart:io';

import 'package:file_picker/file_picker.dart';

class PickerFunctions {
  Future<File?> image() async {
    final FilePickerResult? file = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (file == null) return null;
    return File(file.paths.first!);
  }

  Future<List<File>> images() async {
    final FilePickerResult? file = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);
    if (file == null) return <File>[];
    List<File> temp = <File>[];
    for (PlatformFile element in file.files) {
      temp.add(File(element.path!));
    }
    return temp;
  }
  Future<List<File>> videos() async {
    final FilePickerResult? file = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.video);
    if (file == null) return <File>[];
    List<File> temp = <File>[];
    for (PlatformFile element in file.files) {
      temp.add(File(element.path!));
    }
    return temp;
  }
}
