import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController tripNameController = TextEditingController();
  final TextEditingController tripDateController = TextEditingController();
  final TextEditingController hotelAddressController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController daysController = TextEditingController();

  int uniqueId = 26;
  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 12.0, right: 16, left: 16),
                child: Text(
                  'Add Event',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 16, left: 16),
                child: TextField(
                  controller: tripNameController,
                  decoration: InputDecoration(
                    labelText: 'Event Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 16, left: 16),
                child: InkWell(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                        tripDateController.text =
                            dateFormatter.format(selectedDate);
                      });
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: tripDateController,
                      decoration: InputDecoration(
                        labelText: 'Event Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 16, left: 16),
                child: TextField(
                  controller: daysController,
                  decoration: InputDecoration(
                    labelText: 'Days',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 16, left: 16),
                child: TextField(
                  controller: hotelAddressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 16, left: 16),
                child: TextField(
                  controller: ratingController,
                  decoration: InputDecoration(
                    labelText: 'City Rating',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 16, left: 16),
                child: TextField(
                  controller: aboutController,
                  decoration: InputDecoration(
                    labelText: 'About',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  maxLines: 3,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                      onPressed: () {
                        final tripName = tripNameController.text;
                        final tripDate = tripDateController.text;
                        final hotelAddress = hotelAddressController.text;
                        final rating = ratingController.text;
                        final about = aboutController.text;
                        final days = daysController.text;
                        final time = DateTime.now().toIso8601String();

                        final currentUniqueId = uniqueId;
                        uniqueId++;

                        const outerbaseUrl =
                            'https://horizontal-tomato.cmd.outerbase.io/add-trip';

                        final payload = {
                          'id': currentUniqueId.toString(),
                          'event_name': tripName,
                          'date': tripDate,
                          'address': hotelAddress,
                          'rating': rating,
                          'about': about,
                          'days': days,
                          'createdAt': time,
                        };

                        // Sending data to Outerbase
                        http
                            .post(Uri.parse(outerbaseUrl),
                                body: jsonEncode(payload))
                            .then((response) {
                          if (response.statusCode == 200) {
                            print('Data sent to Outerbase successfully.');
                          } else {
                            print(
                                'Failed to send data to Outerbase. Status code: ${response.statusCode}');
                          }
                        }).catchError((error) {
                          print('Error sending data to Outerbase: $error');
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
