import 'package:flutter/material.dart';
import 'package:gausampada/const/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class VideoMessageWidget extends StatefulWidget {
  final String videoURL;
  final double width;
  final double height;

  const VideoMessageWidget({
    super.key,
    required this.videoURL,
    this.width = 200,
    this.height = 200,
  });

  @override
  State<VideoMessageWidget> createState() => _VideoMessageWidgetState();
}

class _VideoMessageWidgetState extends State<VideoMessageWidget> {
  String? _thumbnailURL;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // print('Video URL: ${widget.videoURL}');
    _validateAndLoadThumbnail();
  }

  Future<void> _validateAndLoadThumbnail() async {
    final uri = Uri.tryParse(widget.videoURL);
    if (uri == null) {
      // print('URL Parsing Error: Invalid URL format');
      setState(() {
        _errorMessage = 'Invalid video URL format';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.head(uri);
      // print('HTTP HEAD Response: ${response.statusCode}');
      if (response.statusCode != 200) {
        setState(() {
          _errorMessage =
              'Video URL inaccessible (Status: ${response.statusCode})';
          _isLoading = false;
        });
        return;
      }
      // Generate thumbnail URL
      setState(() {
        _thumbnailURL = widget.videoURL
            .replaceAll('.mp4', '.jpg')
            .replaceAll('/upload/', '/upload/fl_attachment:thumbnail/');
        _isLoading = false;
      });
    } catch (e) {
      // print('HTTP HEAD Error: $e');
      setState(() {
        _errorMessage = 'Failed to validate URL: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _launchVideo() async {
    final uri = Uri.parse(widget.videoURL);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
      // print('Launch URL Result: $launched');
      if (!launched) {
        setState(() {
          _errorMessage = 'Failed to launch video.';
          _isLoading = false;
        });
      }
    } catch (e) {
      // print('URL Launch Error: $e\nStackTrace: $stackTrace');
      setState(() {
        _errorMessage = 'Failed to launch video: $e';
        _isLoading = false;
      });
    }
  }

  void _retry() {
    setState(() {
      _errorMessage = null;
      _thumbnailURL = null;
      _isLoading = true;
    });
    _validateAndLoadThumbnail();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: themeColor))
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _retry,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                )
              : _thumbnailURL != null
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _thumbnailURL!,
                            width: widget.width,
                            height: widget.height,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // print('Thumbnail Load Error: $error');
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Failed to load thumbnail',
                                    style: TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: _retry,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: themeColor),
                                    child: const Text(
                                      'Retry',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.play_circle_filled,
                            color: backgroundColor,
                            size: 50,
                          ),
                          onPressed: _launchVideo,
                        ),
                      ],
                    )
                  : const Center(
                      child: Text('Failed to load video',
                          style: TextStyle(color: Colors.red))),
    );
  }
}
