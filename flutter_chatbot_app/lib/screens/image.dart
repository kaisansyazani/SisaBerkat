import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'bottom_nav_bar.dart';

class ImageAnalysisScreen extends StatefulWidget {
  @override
  _ImageAnalysisScreenState createState() => _ImageAnalysisScreenState();
}

class _ImageAnalysisScreenState extends State<ImageAnalysisScreen> {
  XFile? pickedImageFile;
  String analysisResult = "";

  Future<String> convertImageToBase64(XFile imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> sendImageForAnalysis(XFile imageFile) async {
    setState(() {
      analysisResult = "Analyzing image...";
    });

    final base64Image = await convertImageToBase64(imageFile);
    const apiKey = 'openai-key'; // Replace with your actual OpenAI API key
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = {
      "model": "gpt-4-turbo",
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text":
                  "You are an expert in identifying different fruits and vegetables. Analyze their quality and tell the user whether they are fresh, overripe, or spoiled. Provide clear recommendations based on your observations, shorten your answer, be simple and clear."
            },
            {
              "type": "image_url",
              "image_url": {
                "url": "data:image/jpeg;base64,$base64Image"
              }
            }
          ]
        }
      ],
      "max_tokens": 1000
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          analysisResult = responseData['choices'][0]['message']['content'];
        });
      } else {
        setState(() {
          analysisResult =
              'Failed to get a response. Status code: ${response.statusCode}\n${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        analysisResult = 'Error: $e';
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        pickedImageFile = pickedFile;
      });
      sendImageForAnalysis(pickedImageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    const pastelGreen = Color(0xFFDFF6DD); // Light pastel green
    const white = Colors.white;

    return Scaffold(
      backgroundColor: pastelGreen,
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          'Image Analysis with GPT-4',
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (pickedImageFile != null) ...[
                  Image.file(
                    File(pickedImageFile!.path),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                ],
                ElevatedButton(
                  onPressed: pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: white,
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Pick an Image'),
                ),
                SizedBox(height: 20),
                if (pickedImageFile != null)
                  Text("Image Selected: ${pickedImageFile!.name}"),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    analysisResult.isNotEmpty
                        ? analysisResult
                        : "waiting for image analysis...",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ), 
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
