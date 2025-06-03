import 'package:flutter/material.dart';
import 'package:gausampada/const/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VideoPickerWidget extends StatelessWidget {
  final Function(File?) onVideoPicked;

  const VideoPickerWidget({super.key, required this.onVideoPicked});

  Future<void> _pickVideo(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      onVideoPicked(File(video.path));
    } else {
      onVideoPicked(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.videocam, color: themeColor),
      onPressed: () => _pickVideo(context),
      tooltip: 'Pick Video',
    );
  }
}
