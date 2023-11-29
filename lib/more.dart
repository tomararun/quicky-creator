import 'package:flutter/material.dart';
import 'mail.dart';
import 'payment.dart';

import 'sms.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
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
        title: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
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
                        Icons.mail,
                        size: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: Text(
                          '',
                          style: TextStyle(
                            fontFamily: 'aperture2.0-webfont',
                            fontSize: 22,
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
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.sms,
                        size: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: Text(
                          '',
                          style: TextStyle(
                            fontFamily: 'aperture2.0-webfont',
                            fontSize: 22,
                            color: _currentIndex == 1
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
                    padding: EdgeInsets.only(top: 4.0, bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.currency_rupee_outlined,
                          size: 20,
                        ),
                        Text(
                          ' Payments',
                          style: TextStyle(
                            fontFamily: 'aperture2.0-webfont',
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [Mail(), Sms(), Payment()],
      ),
    );
  }
}
