import 'package:flutter/material.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          // Create link section at the top
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0XFF018169),
              child: Icon(Icons.link, color: Colors.white),
            ),
            title: const Text("Create call link", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
            subtitle: const Text("Share a link for your WhatsApp call", style: TextStyle(fontFamily: 'Roboto')),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text("Recent", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
          ),

          // Example call logs
          _buildCallLog("Fahim", "Today, 10:45 AM", isVideo: true, isMissed: true),
          _buildCallLog("Siam", "Yesterday, 9:20 PM", isVideo: false, isMissed: false),
          _buildCallLog("Apurbo", "October 25, 4:00 PM", isVideo: true, isMissed: false),
        ],
      ),
      // Floating button for making a new call
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0XFF25D366),
        child: const Icon(Icons.add_call, color: Colors.white),
      ),
    );
  }

  // Helper widget to build call log entries
  Widget _buildCallLog(String name, String time, {bool isVideo = false, bool isMissed = false}) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(0XFFF0F2F3),
        child: Icon(Icons.person, color: Colors.grey),
      ),
      title: Text(name, style: TextStyle(color: isMissed ? Colors.red : Colors.black, fontWeight: FontWeight.bold)),
      subtitle: Row(
        children: [
          Icon(
            isMissed ? Icons.call_missed : Icons.call_made,
            color: isMissed ? Colors.red : Colors.green,
            size: 16,
          ),
          const SizedBox(width: 5),
          Text(time, style: const TextStyle(color: Colors.grey)),
        ],
      ),
      trailing: Icon(isVideo ? Icons.videocam : Icons.call, color: const Color(0XFF018169)),
    );
  }
}
