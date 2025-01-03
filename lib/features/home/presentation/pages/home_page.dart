import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _catImageUrl;

  Future<void> _fetchCatImage() async {
    final response = await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      setState(() {
        _catImageUrl = data[0]['url'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCatImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: _catImageUrl == null
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(_catImageUrl!, height: 300, fit: BoxFit.cover),
            ElevatedButton(
              onPressed: _fetchCatImage,
              child: Text('Fetch Another Cat'),
            ),
          ],
        ),
      ),
    );
  }
}