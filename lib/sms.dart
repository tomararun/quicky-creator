import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Sms extends StatefulWidget {
  const Sms({super.key});

  @override
  State<Sms> createState() => _SmsState();
}

class _SmsState extends State<Sms> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _textEditingController = TextEditingController();

  void _sendTextToOuterbase() {
    final phone = _phoneController.text;
    final message = _textEditingController.text;
    const outerbaseUrl = 'https://horizontal-tomato.cmd.outerbase.io/twilio';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('To: $phone'),
              Text('Message: $message'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                final payload = {
                  'phone': phone,
                  'message': message,
                };

                http
                    .post(Uri.parse(outerbaseUrl), body: jsonEncode(payload))
                    .then((response) {
                  if (response.statusCode == 200) {
                    print('Data sent to Outerbase successfully.');
                    _showSuccessDialog();
                  } else {
                    print(
                        'Failed to send data to Outerbase. Status code: ${response.statusCode}');
                  }
                }).catchError((error) {
                  print('Error sending data to Outerbase: $error');
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('SMS sent successfully.'),
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
          "Personalized Text",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins-Medium',
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35), topRight: Radius.circular(35))),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              maxLines: 3,
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _sendTextToOuterbase();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              child: const Text("Send"),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
