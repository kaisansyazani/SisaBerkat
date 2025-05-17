// Combined MultiAIScreen with Image Analysis and Chat
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'bottom_nav_bar.dart';
import 'app_drawer.dart';

class MultiAIScreen extends StatefulWidget {
  @override
  _MultiAIScreenState createState() => _MultiAIScreenState();
}

class _MultiAIScreenState extends State<MultiAIScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  late stt.SpeechToText _speech;
  final FlutterTts _flutterTts = FlutterTts();
  final ImagePicker _picker = ImagePicker();

  bool _isListening = false;

  final gpt4ApiKey = 'openai-key';
  final gpt35ApiKey = 'openai-key';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _speech = stt.SpeechToText();
    _initSpeech();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) await Permission.microphone.request();

    bool available = await _speech.initialize(
      onStatus: (val) => setState(() => _isListening = val != "done"),
      onError: (val) {
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Speech error: ${val.errorMsg}")),
        );
      },
    );

    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Speech recognition not available")),
      );
    }
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: 'en_US',
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1);
    await _flutterTts.speak(text);
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _messages.add({'role': 'user', 'content': '[Image selected: ${pickedFile.name}]'});
        _isLoading = true;
      });

      final base64Image = base64Encode(await pickedFile.readAsBytes());

      final body = {
        "model": "gpt-4-turbo",
        "messages": [
          {
            "role": "user",
            "content": [
              {
                "type": "text",
                "text": "You are an expert in identifying fruits and vegetables. Say if they're fresh or spoiled and give recommendation what you can do with it to avoid wasting it.Give no mre than 3 options for the first time answering"
              },
              {
                "type": "image_url",
                "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
              }
            ]
          }
        ],
        "max_tokens": 1000
      };

      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          'Authorization': 'Bearer $gpt4ApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final reply = response.statusCode == 200
          ? jsonDecode(response.body)['choices'][0]['message']['content']
          : 'Image analysis failed: ${response.statusCode}';

      setState(() {
        _messages.add({'role': 'assistant', 'content': reply});
        _isLoading = false;
      });
    }
  }

  Future<void> sendMessage(String prompt) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $gpt35ApiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content": '''
You are an expert agricultural assistant in food wastage. You help farmers and users understand crop plans and food waste options.Give prediction when they give their crop plan .Predict and calculate based on crop type weather and place.The weather you can look it up in google fot the location's weather prediction.Next, give recommendations to regarding food waste.Give recipes and ideas. Keep your answers friendly, helpful and not too long.
'''
          },
          {"role": "user", "content": prompt}
        ]
      }),
    );

    final reply = response.statusCode == 200
        ? json.decode(response.body)['choices'][0]['message']['content']
        : 'Error: ${response.statusCode}';

    setState(() {
      _messages.add({'role': 'user', 'content': prompt});
      _messages.add({'role': 'assistant', 'content': reply});
      _isLoading = false;
    });
  }

  Widget buildMessage(String role, String content) {
    return Align(
      alignment: role == 'user' ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: role == 'user' ? Color(0xFF8BC34A) : Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(content, style: GoogleFonts.poppins(fontSize: 14)),
            if (role == 'assistant')
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(Icons.volume_up, size: 20),
                  onPressed: () => _speak(content),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F5E9),
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, -_bounceAnimation.value),
                child: child,
              ),
              child: Text("🤖", style: TextStyle(fontSize: 26)),
            ),
            SizedBox(width: 8),
            Text("AgriAssist", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87)),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: _messages.map((msg) => buildMessage(msg['role']!, msg['content']!)).toList(),
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: 12),
                  CircularProgressIndicator(strokeWidth: 2),
                  SizedBox(width: 12),
                  Text("Izal is thinking...", style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Row(
              children: [
                IconButton(icon: Icon(Icons.image), onPressed: pickImage),
                IconButton(icon: Icon(_isListening ? Icons.mic_off : Icons.mic), onPressed: _listen),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask something...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: GoogleFonts.poppins(),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Color(0xFF8BC34A),
                  child: _isLoading
                      ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 2.5)
                      : IconButton(
                          icon: Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            final prompt = _controller.text.trim();
                            if (prompt.isNotEmpty && !_isLoading) {
                              sendMessage(prompt);
                              _controller.clear();
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
