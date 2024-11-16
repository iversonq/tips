import 'package:flutter/material.dart';
import 'login.dart'; // Import LoginPage
import 'register.dart'; // Import RegisterScreen
import 'home.dart'; // Import HomeScreen if it is defined in another file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Navigation Demo',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const HomePage(), // HomePage is set as the starting page
    );
  }
}

// Define HomePage widget here if it’s the starting screen
class HomePage extends StatelessWidget {
  const HomePage({super.key}); // Make the constructor const

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'image/bghome.png', // Ensure this path is correct
            fit: BoxFit.cover,
          ),
          // Button at the bottom
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0), // Adjust padding as needed
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the login page when the button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text('GET START'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}