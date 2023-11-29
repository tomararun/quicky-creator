import 'package:flutter/material.dart';
import 'add.dart';
import 'prompt.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'event_details.dart';
import 'more.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  void _changeScreen(int index) {
    setState(() {
      _currentIndex = index;
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          children: [
            ElevatedButton(
              onPressed: () => _changeScreen(0),
              style: ElevatedButton.styleFrom(
                foregroundColor: _currentIndex == 0
                    ? Theme.of(context).colorScheme.background
                    : Theme.of(context).colorScheme.primary,
                backgroundColor: _currentIndex == 0
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: _currentIndex == 0
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.rocket_launch_rounded,
                      size: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: Text(
                        ' proShare',
                        style: TextStyle(
                          fontFamily: 'Poppins-Medium',
                          fontSize: 20,
                          color: _currentIndex == 0
                              ? Theme.of(context).colorScheme.background
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              onPressed: () => _changeScreen(1),
              style: ElevatedButton.styleFrom(
                foregroundColor: _currentIndex == 1
                    ? Theme.of(context).colorScheme.background
                    : Theme.of(context).colorScheme.primary,
                backgroundColor: _currentIndex == 1
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: _currentIndex == 1
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Icon(
                    Icons.adobe_rounded,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _changeScreen(2),
              style: ElevatedButton.styleFrom(
                foregroundColor: _currentIndex == 2
                    ? Theme.of(context).colorScheme.background
                    : Theme.of(context).colorScheme.primary,
                backgroundColor: _currentIndex == 2
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: _currentIndex == 2
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Icon(
                    Icons.more_rounded,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [DataListScreen(), Prompt(), More()],
      ),
    );
  }
}

class DataListScreen extends StatefulWidget {
  const DataListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DataListScreenState createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchData().then((result) {
      setState(() {
        data = result;
      });
    });
  }

  Map<String, dynamic> parseOuterbaseResponse(String response) {
    final cleanedResponse = response.replaceAllMapped(
      RegExp(r'^\s*\{(.+)\}:\s*\d{3}\s*$'),
      (match) => match.group(1)!,
    );
    return json.decode(cleanedResponse);
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://horizontal-tomato.cmd.outerbase.io/list-trip'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse =
            parseOuterbaseResponse(response.body);

        final List<dynamic> items = jsonResponse['response']['items'];

        // Sorting the items by 'createdAt' field in descending order
        items.sort((a, b) {
          final DateTime dateA = DateTime.parse(a['createdAt']);
          final DateTime dateB = DateTime.parse(b['createdAt']);
          return dateB.compareTo(dateA);
        });

        return items.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Events",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins-Medium',
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final result = await fetchData();
                setState(() {
                  data = result;
                });
              },
              icon: const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(
                  Icons.refresh_outlined,
                  color: Colors.black,
                ),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.background,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Add();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final trip = data[index];
          final isLastItem = index == data.length - 1;

          return Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 4.0,
              bottom: isLastItem ? 100.0 : 0.0,
            ),
            child: GestureDetector(
              onTap: () {
                _showTripDetailsBottomSheet(context, trip);
              },
              child: Card(
                color: Colors.grey[300],
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.grey[300],
                    child: ListTile(
                      title: Text(
                        trip['event_name'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Poppins-Medium',
                        ),
                      ),
                      subtitle: Text(
                        trip['address'].toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Medium',
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _showDeleteConfirmationDialog(trip['id']);
                        },
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(int itemId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteItem(itemId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteItem(int itemId) async {
    try {
      const String deleteUrl =
          'https://horizontal-tomato.cmd.outerbase.io/delete-trip';

      final Map<String, dynamic> payload = {'id': itemId};

      final response = await http.delete(
        Uri.parse(deleteUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_outlined,
                    color: Colors.green,
                  ),
                  Text('Item Deleted'),
                ],
              ),
              content: const Text('The item has been successfully deleted.'),
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

        // Refreshing the data
        final result = await fetchData();
        setState(() {
          data = result;
        });
      } else {
        print('Failed to delete item. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting item: $error');
    }
  }

  void _showTripDetailsBottomSheet(
      BuildContext context, Map<String, dynamic> trip) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return EventDetailsPage(trip: trip);
      },
    );
  }
}
