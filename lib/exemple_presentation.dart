import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _selectedImage;
  String _result = "";

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      final result = await recognizeText(_selectedImage!);
      setState(() {
        _result = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KTP & NPWP Scanner')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_selectedImage != null)
            Image.file(_selectedImage!, height: 300, fit: BoxFit.contain),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Gallery'),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(_result),
        ],
      ),
    );
  }
}

Future<String> recognizeText(File imageFile) async {
  final inputImage = InputImage.fromFile(imageFile);
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);

  return recognizedText.text;
}
