import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PickerFunctions {
  Future<File?> image() async {
    final bool isGranted = await _request();
    if (!isGranted) return null;
    final FilePickerResult? file = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (file == null) return null;
    return File(file.paths.first!);
  }

  Future<List<File>> images() async {
    final bool isGranted = await _request();
    if (!isGranted) return <File>[];
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
    final bool isGranted = await _request();
    if (!isGranted) return <File>[];
    final FilePickerResult? file = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.video);
    if (file == null) return <File>[];
    List<File> temp = <File>[];
    for (PlatformFile element in file.files) {
      temp.add(File(element.path!));
    }
    return temp;
  }

  Future<bool> _request() async {
    await <Permission>[Permission.photos, Permission.mediaLibrary].request();
    final PermissionStatus status1 = await Permission.photos.status;
    final PermissionStatus status2 = await Permission.mediaLibrary.status;
    return status1.isGranted && status2.isGranted;
  }
}
