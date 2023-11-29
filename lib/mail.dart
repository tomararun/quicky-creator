import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Mail extends StatefulWidget {
  const Mail({super.key});

  @override
  State<Mail> createState() => _MailState();
}

class _MailState extends State<Mail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _textEditingController = TextEditingController();

  // Validating email address.
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  void _sendMailToOuterbase() {
    final email = _emailController.text;
    final message = _textEditingController.text;
    const outerbaseUrl = 'https://horizontal-tomato.cmd.outerbase.io/mail-gun';

    if (!_isValidEmail(email)) {
      _showErrorDialog('Invalid Email', 'Please enter a valid email address.');
      return;
    }

    final payload = {
      'email': email,
      'message': message,
    };

    // confirmation before submitting.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('To: $email'),
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

  // error dialog.
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  //success dialog.
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Mail sent successfully.'),
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
          "Personalized Mail",
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
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
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
                _sendMailToOuterbase();
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
