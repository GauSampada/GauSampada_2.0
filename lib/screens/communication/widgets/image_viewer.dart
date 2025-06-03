import 'package:flutter/material.dart';
import 'package:gausampada/const/colors.dart';

class ImageViewerPage extends StatelessWidget {
  final String imageUrl;

  const ImageViewerPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text(
          'Image Viewer',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.black, // Black background for image viewer
        child: Center(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain, // Preserve aspect ratio
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return CircularProgressIndicator(
                color: themeColor,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print('Image Load Error: $error\nStackTrace: $stackTrace');
              return const Text(
                'Failed to load image',
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
      ),
    );
  }
}
