import 'package:flutter/material.dart';
import 'package:gausampada/const/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerWidget extends StatelessWidget {
  final Function(File?) onImagePicked;

  const ImagePickerWidget({super.key, required this.onImagePicked});

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      onImagePicked(File(image.path));
    } else {
      onImagePicked(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.photo, color: themeColor),
      onPressed: () => _pickImage(context),
      tooltip: 'Pick Image',
    );
  }
}
