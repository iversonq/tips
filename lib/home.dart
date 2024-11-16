import 'package:flutter/material.dart';
import 'trip_summary.dart'; // Ensure this file exists
import 'notes.dart';        // Ensure this file exists
import 'budget.dart';       // Ensure this file exists
import 'profile.dart';      // Ensure this file exists

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    TripSummaryScreen(),
    NotesScreen(),
    BudgetScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display selected page
      bottomNavigationBar: Container(
        color: Color(0xFF9E8A9D), // Dark purple background for navigation bar
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildNavItem(Icons.home, "HOME", 0),
            buildNavItem(Icons.airplane_ticket, "Trip Summary", 1),
            buildNavItem(Icons.note, "Notes", 2),
            buildNavItem(Icons.pie_chart, "Budget", 3),
            buildNavItem(Icons.person, "Profile", 4),
          ],
        ),
      ),
    );
  }

  GestureDetector buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Colors.black : Colors.white,
            size: 30,
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Colors.black : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  // List of places with name, image path, entrance fee, and details
  final List<Map<String, String>> places = [
    {
      'name': 'Place 1',
      'image': 'image/place1.jpg', // Local image
      'entrance': 'Entrance Fee: \$20',
      'details': 'This is the description for Place 1.'
    },
    {
      'name': 'Place 2',
      'image': 'image/place2.jpg', // Local image
      'entrance': 'Entrance Fee: \$25',
      'details': 'This is the description for Place 2.'
    },
    {
      'name': 'Place 3',
      'image': 'image/place3.jpg', // Local image
      'entrance': 'Entrance Fee: \$15',
      'details': 'This is the description for Place 3.'
    },
    {
      'name': 'Place 4',
      'image': 'image/place4.jpg', // Local image
      'entrance': 'Entrance Fee: \$10',
      'details': 'This is the description for Place 4.'
    },
    {
      'name': 'Place 5',
      'image': 'image/place5.jpg', // Local image
      'entrance': 'Entrance Fee: \$30',
      'details': 'This is the description for Place 5.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tourist spot in Tarlac'),
        centerTitle: true, // Centers the title
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'image/bghomepage.png', // Your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Content (overlaid on top of the background image)
          SingleChildScrollView(
            child: Column(
              children: List.generate(places.length, (index) {
                return GestureDetector(
                  onTap: () {
                    // Show the details when the image is clicked
                    _showDetailsDialog(context, places[index]);
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    elevation: 5,
                    child: Container(
                      height: 250,  // Increase the height to make the button bigger
                      child: Row(
                        children: [
                          // Display the image with increased size
                          Image.asset(
                            places[index]['image']!, // Load local image
                            width: 150,  // Increase the width of the image
                            height: 150, // Increase the height of the image
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10),
                          // Display the name and entrance fee
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  places[index]['name']!,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  places[index]['entrance']!,
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          // Arrow icon to indicate more details
                          Icon(Icons.arrow_forward, size: 30),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the details dialog when a button is clicked
  void _showDetailsDialog(BuildContext context, Map<String, String> place) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(place['name']!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(place['image']!),  // Load local image
            SizedBox(height: 10),
            Text(place['entrance']!),
            SizedBox(height: 10),
            Text(place['details']!),
          ],
        ),
        actions: [
          // Close button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
          // New button - for example, 'More Details'
          TextButton(
            onPressed: () {
              // Implement your action here, for example, navigate to another screen
              Navigator.of(context).pop(); // You can modify this action as needed
              print("Added to the trip summary");
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
