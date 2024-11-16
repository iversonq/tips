import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  // Controllers for input fields
  final TextEditingController airfareController = TextEditingController();
  final TextEditingController accommodationController = TextEditingController();
  final TextEditingController transportController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController mealsController = TextEditingController();

  double totalBudget = 0.0;
  bool isEnabled = true; // Controls whether text fields are enabled
  bool showDoneButton = false; // Controls visibility of the "Done" button

  @override
  void initState() {
    super.initState();
    // Add listeners to update button visibility
    airfareController.addListener(checkFields);
    accommodationController.addListener(checkFields);
    transportController.addListener(checkFields);
    taxController.addListener(checkFields);
    mealsController.addListener(checkFields);
  }

  // Check if all fields are filled
  void checkFields() {
    setState(() {
      showDoneButton = airfareController.text.isNotEmpty &&
          accommodationController.text.isNotEmpty &&
          transportController.text.isNotEmpty &&
          taxController.text.isNotEmpty &&
          mealsController.text.isNotEmpty;
    });
  }

  // Calculate the total budget
  void calculateTotalBudget() {
    double airfare = double.tryParse(airfareController.text) ?? 0.0;
    double accommodation = double.tryParse(accommodationController.text) ?? 0.0;
    double transport = double.tryParse(transportController.text) ?? 0.0;
    double tax = double.tryParse(taxController.text) ?? 0.0;
    double meals = double.tryParse(mealsController.text) ?? 0.0;

    setState(() {
      totalBudget = airfare + accommodation + transport + tax + meals;
      isEnabled = false; // Disable text fields
    });
  }

  // Reset all fields
  void resetFields() {
    setState(() {
      airfareController.clear();
      accommodationController.clear();
      transportController.clear();
      taxController.clear();
      mealsController.clear();
      totalBudget = 0.0;
      isEnabled = true; // Re-enable text fields
      showDoneButton = false; // Hide the "Done" button
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('image/bgbudget1.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTextField('Airfare or Fees', airfareController),
                  buildTextField('Accommodation', accommodationController),
                  buildTextField('Transport Costs', transportController),
                  buildTextField('Departure Tax', taxController),
                  buildTextField('Meals During Travel', mealsController),
                  SizedBox(height: 20),
                  // Show "Done" button only if all fields are filled
                  if (showDoneButton)
                    ElevatedButton(
                      onPressed: calculateTotalBudget,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  SizedBox(height: 20),
                  // Display total budget
                  Text(
                    'Total Budget: \$${totalBudget.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Finished Travel button
                  ElevatedButton(
                    onPressed: () {
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmation'),
                            content: Text(
                                'Are you sure you want to finish the travel?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                  resetFields(); // Reset all fields
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Travel finished!')),
                                  );
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                    ),
                    child: Text(
                      'Finished Travel',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build a text field
  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        enabled: isEnabled, // Disable or enable text field
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}