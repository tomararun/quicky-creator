import 'package:flutter/material.dart';
import 'home.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

void main() {
  runApp(const Quicky());
}

// ignore: camel_case_types
class Quicky extends StatelessWidget {
  const Quicky({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const TripPlannerScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch_rounded,
              size: 30,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Quicky',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins-Medium',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  _TripPlannerScreenState createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Home(),
    );
  }
}
