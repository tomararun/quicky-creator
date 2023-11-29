import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  List<Map<String, dynamic>> data = [];
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData().then((result) {
      setState(() {
        data = result;
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(
      Uri.parse('https://horizontal-tomato.cmd.outerbase.io/stripe-get'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> items = jsonResponse['data'];

      return items.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _showPhoneNumberDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: const Row(
            children: [
              Icon(Icons.link_rounded),
              SizedBox(
                width: 4,
              ),
              Text("Payment Link"),
            ],
          ),
          content: TextField(
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Number to SMS Link',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              onPressed: () async {
                final phoneNumber = phoneNumberController.text;

                const outerbaseUrl =
                    'https://horizontal-tomato.cmd.outerbase.io/stripe';

                final payload = {
                  'phone': phoneNumber, // Convert ID to string
                };

                http
                    .post(Uri.parse(outerbaseUrl), body: jsonEncode(payload))
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
              child: const Text("Send"),
            ),
            const SizedBox(
              width: 10,
            )
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
          "Latest Payments",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins-Medium',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showPhoneNumberDialog();
            },
            icon: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.link_rounded,
                color: Colors.black,
              ),
            ),
          ),
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
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final payment = data[index];
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.green[100],
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.green.shade200,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      '${payment['id']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () async {
                                      await FlutterClipboard.copy(
                                          payment['id']);

                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          padding: const EdgeInsets.all(8.0),
                                          backgroundColor: Colors.transparent,
                                          content: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.black),
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Transaction ID copied !',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.copy_all_rounded,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Badge(
                  largeSize: 30,
                  backgroundColor: Colors.amber,
                  label: Row(
                    children: [
                      Text(
                        ' ${payment['currency'].toString().toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        ' ${payment['amount'] / 100 ?? 'N/A'} ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
