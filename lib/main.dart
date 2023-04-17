import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: 'Papago 번역기',
    home: TranslationApp(),
  ));
}

class TranslationApp extends StatefulWidget {
  @override
  _TranslationAppState createState() => _TranslationAppState();
}

class _TranslationAppState extends State<TranslationApp> {
  String _client_id = "w4lp2Y2UYyYG96qVmqhY";
  String _client_secret = "gLer4YYvvo";
  String _content_type = "application/x-www-form-urlencoded; charset=UTF-8";
  String _url = "https://openapi.naver.com/v1/papago/n2mt";

  final TextEditingController _textController = TextEditingController();
  String _translatedText = '';

  Future<void> getTranslation_papago() async {
    http.Response trans = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': _content_type,
        'X-Naver-Client-Id': _client_id,
        'X-Naver-Client-Secret': _client_secret
      },
      body: {
        'source': 'en',
        'target': 'ko',
        'text': _textController.text,
      },
    );
    if (trans.statusCode == 200) {
      var dataJson = jsonDecode(trans.body);
      setState(() {
        _translatedText = dataJson['message']['result']['translatedText'];
      });
    } else {
      print(trans.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Papago 번역기'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '번역할 텍스트를 입력하세요',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              getTranslation_papago();
            },
            child: Text('번역하기'),
          ),
          SizedBox(height: 20),
          Text(
            _translatedText,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
