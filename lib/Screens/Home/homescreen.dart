import 'package:flutter/material.dart';
import 'package:app/Screens/Home/chats_screen.dart';
import 'package:app/Screens/Home/updates_screen.dart';
import 'package:app/Screens/Home/calls_screen.dart';
import 'package:app/Screens/Home/communities_screen.dart'; // Step 1: Import the new Communities screen

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // Index to track which tab is selected
  int _selectedIndex = 0;

  // Step 2: List of all screens for the bottom navigation
  final List<Widget> _screens = [
    const ChatsScreen(),
    const UpdatesScreen(),
    const CommunitiesScreen(), // Added our new screen here
    const CallsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "WhatsApp",
          style: TextStyle(
            color: Color(0XFF018169),
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.black87),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.black87),
          ),
        ],
      ),
      // Step 3: Body changes automatically based on selected index
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          // Step 4: Change the index when a tab is clicked
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0XFF018169),
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.circle_outlined), label: "Updates"),
          BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: "Communities"),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
        ],
      ),
    );
  }
}
