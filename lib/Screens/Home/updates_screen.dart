import 'package:flutter/material.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const SizedBox(height: 10),
          // Heading for the Status section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "Status", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Roboto')
            ),
          ),
          
          // Current User's Status
          ListTile(
            leading: Stack(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0XFFF0F2F3),
                  child: Icon(Icons.person, color: Colors.grey, size: 30),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Color(0XFF018169), shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: Colors.white, size: 15),
                  ),
                ),
              ],
            ),
            title: const Text("My status", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
            subtitle: const Text("Tap to add status update", style: TextStyle(fontFamily: 'Roboto')),
          ),
          
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "Recent updates", 
              style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)
            ),
          ),
          
          // Dummy status updates from contacts
          _buildStatusTile("Fahim", "10 minutes ago"),
          _buildStatusTile("Siam", "Today, 12:30 PM"),
          _buildStatusTile("Apurbo", "Yesterday, 11:00 PM"),
        ],
      ),
      // Floating button to take a photo for status
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0XFF25D366),
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
    );
  }

  // Helper widget to build friend's status rows
  Widget _buildStatusTile(String name, String time) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0XFF018169), width: 2),
        ),
        child: const CircleAvatar(
          radius: 23,
          backgroundColor: Color(0XFFF0F2F3),
          child: Icon(Icons.person, color: Colors.grey),
        ),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
      subtitle: Text(time, style: const TextStyle(fontFamily: 'Roboto')),
    );
  }
}
