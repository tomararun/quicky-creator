import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Prompt extends StatefulWidget {
  const Prompt({Key? key}) : super(key: key);

  @override
  State<Prompt> createState() => _PromptState();
}

class _PromptState extends State<Prompt> {
  final TextEditingController _textEditingController = TextEditingController();

  void _sendPromptToOuterbase() {
    final prompt = _textEditingController.text;
    const outerbaseUrl = 'https://horizontal-tomato.cmd.outerbase.io/open-ai';

    final payload = {
      'prompt': prompt,
    };

    http
        .post(Uri.parse(outerbaseUrl), body: jsonEncode(payload))
        .then((response) {
      if (response.statusCode == 200) {
        _showSuccessDialog();
        print('Data sent to Outerbase successfully.');
      } else {
        print(
            'Failed to send data to Outerbase. Status code: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error sending data to Outerbase: $error');
    });
  }

  //success dialog.
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Data sent to Discord successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Share AI Prompt",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins-Medium',
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35), topRight: Radius.circular(35))),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              maxLines: 3,
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Prompt',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _sendPromptToOuterbase();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              child: const Text("Submit to Discord"),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
