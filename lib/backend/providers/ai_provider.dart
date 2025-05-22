import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AiProvider extends ChangeNotifier {
  String _imageTextResponse = "";
  bool _isLoading = false;
  bool _hasAnalyzed = false;
  String? _analyzedImagePath;
  String _analyzedPrompt = "";

  // Getters
  String get imageTextResponse => _imageTextResponse;
  bool get isLoading => _isLoading;
  bool get hasAnalyzed => _hasAnalyzed;
  String? get analyzedImagePath => _analyzedImagePath;
  String get analyzedPrompt => _analyzedPrompt;

  // Reset state
  void reset() {
    _imageTextResponse = "";
    _hasAnalyzed = false;
    _analyzedImagePath = null;
    _analyzedPrompt = "";
    notifyListeners();
  }

  // Analyze the selected image
  Future<void> analyzeImage({
    required BuildContext context,
    required XFile image,
    required String prompt,
  }) async {
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a prompt")),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      List<int> imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      await getImageTextResponse(
        prompt: prompt,
        imageBase64: base64Image,
      );

      // Store the analyzed image path and prompt
      _analyzedImagePath = image.path;
      _analyzedPrompt = prompt;
      _hasAnalyzed = true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // API call to get text response from image
  Future<void> getImageTextResponse({
    required String prompt,
    required String imageBase64,
  }) async {
    // String urlHosting =
    //     "https://ai-model-gausampada.onrender.com/image_to_text";
    String urlLocal = "http://10.0.42.125:5000/image_to_text";
    final response = await http.post(
      Uri.parse(urlLocal),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "image_base64": imageBase64,
        "prompt": prompt,
      }),
    );

    if (response.statusCode == 200) {
      _imageTextResponse = jsonDecode(response.body)['result'];
    } else {
      _imageTextResponse =
          "Error: Unable to process image. Status code: ${response.statusCode}";
    }
    notifyListeners();
  }
}
