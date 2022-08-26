import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../utilities/utilities.dart';
import '../custom_widgets/asset_video_player.dart';

class GetProductAttachments extends StatefulWidget {
  const GetProductAttachments({
    required this.file,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final List<PlatformFile?> file;
  final VoidCallback onTap;
  @override
  // ignore: library_private_types_in_public_api
  _GetProductImageAttachments createState() => _GetProductImageAttachments();
}

class _GetProductImageAttachments extends State<GetProductAttachments> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 32 - 20;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: widget.onTap,
            child: Container(
              width: double.infinity,
              height: (width / 5) * 2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                color: Colors.grey[300],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(height: 16),
                  Icon(Icons.add_circle_rounded),
                  SizedBox(height: 6),
                  Text('Add Images/Videos'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: width / 5,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 5),
              itemBuilder: (BuildContext context, int index) => _ImageBox(
                index: index + 1,
                width: width / 5,
                file: widget.file[index],
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: width / 5,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 5),
              itemBuilder: (BuildContext context, int index) => _ImageBox(
                index: index + 6,
                width: width / 5,
                file: widget.file[index + 5],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageBox extends StatelessWidget {
  const _ImageBox({
    required this.index,
    required double width,
    this.file,
    Key? key,
  })  : _width = width,
        super(key: key);

  final double _width;
  final int index;
  final PlatformFile? file;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _width,
      width: _width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: (file == null)
          ? Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.grey[300],
              child: FittedBox(
                child: Text(
                  index.toString(),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.08),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            )
          : SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: (Utilities.isVideo(extension: file!.extension!))
                  ? AssetVideoPlayer(path: file!.path!)
                  : Image.file(File(file!.path!)),
            ),
    );
  }
}
