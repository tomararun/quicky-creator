import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventDetailsPage extends StatefulWidget {
  final Map<String, dynamic> trip;

  const EventDetailsPage({
    Key? key,
    required this.trip,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  void handlePost(String platformName, String platformUrl) {
    // confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Posting to $platformName'),
          content: Text('Post on $platformName ?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Post'),
              onPressed: () {
                final data = {
                  "trip_name": widget.trip['event_name'],
                  "date": widget.trip['date'],
                  "days": widget.trip['days'],
                  "address": widget.trip['address'],
                  "rating": widget.trip['rating'],
                  "about": widget.trip['about'],
                };

                final jsonData = jsonEncode(data);

                http
                    .post(
                  Uri.parse(platformUrl),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: jsonData,
                )
                    .then((response) {
                  if (response.statusCode == 200) {
                    print('Data sent to $platformName successfully.');
                  } else {
                    print(
                        'Failed to send data to $platformName. Status code: ${response.statusCode}');
                  }
                }).catchError((error) {
                  print('Error sending data to $platformName: $error');
                });

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).colorScheme.background,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )),
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.trip['event_name']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.trip['address']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Days: ${widget.trip['days']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
                Text(
                  'Date: ${widget.trip['date']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
                Text(
                  'Rating: ${widget.trip['rating']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
                Text(
                  'About: ${widget.trip['about']}',
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        handlePost(
                          'Slack',
                          'https://horizontal-tomato.cmd.outerbase.io/post-slack',
                        );
                      },
                      icon: const Icon(Icons.bubble_chart_outlined, size: 25),
                    ),
                    IconButton(
                      onPressed: () {
                        handlePost(
                          'Telegram Bot',
                          'https://horizontal-tomato.cmd.outerbase.io/post-telegram',
                        );
                      },
                      icon: const Icon(Icons.telegram_rounded, size: 25),
                    ),
                    IconButton(
                      onPressed: () {
                        handlePost(
                          'Discord Channel',
                          'https://horizontal-tomato.cmd.outerbase.io/post-discord',
                        );
                      },
                      icon: const Icon(Icons.discord_rounded, size: 25),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
