import 'package:flutter/material.dart';
import 'package:project/views/profile_screen.dart'; // Import the ProfileScreen

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,  // Purple color for the app bar
        title: Text(
          'Medical History',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header text
            Text(
              'Medical History List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,  // Purple color for header
              ),
            ),
            SizedBox(height: 20),

            // Simulated medical history list with cards
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Simulate 5 medical history records
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.history,
                        color: Colors.purple,  // Purple color for the icon
                        size: 40,
                      ),
                      title: Text(
                        'History #${index + 1}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Condition: Simulated',
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.purple,  // Purple color for the trailing icon
                      ),
                      onTap: () {
                        // Action when tapping (not yet defined)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Medical history details')),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

