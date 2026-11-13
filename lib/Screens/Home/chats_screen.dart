import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/Screens/Home/chat_detail_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Step 1: Search Bar UI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0XFFF0F2F3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  // Meta AI icon simulation
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [Colors.blue, Colors.purple, Colors.pink, Colors.orange, Colors.blue],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: Container(
                        decoration: const BoxDecoration(color: Color(0XFFF0F2F3), shape: BoxShape.circle),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("Ask Meta AI or Search", style: TextStyle(color: Colors.black54, fontSize: 14)),
                ],
              ),
            ),
          ),

          // Step 2: Filter Chips (All, Unread, etc.)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                _buildFilterChip("All", isSelected: true),
                _buildFilterChip("Unread"),
                _buildFilterChip("Favorites"),
                _buildFilterChip("Groups"),
              ],
            ),
          ),

          // Step 3: Main Chat List from Firebase Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0XFF018169)));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No users found."));
                }

                // Filter out the current user
                var docs = snapshot.data!.docs.where((doc) => doc.id != currentUid).toList();

                if (docs.isEmpty) {
                  return const Center(child: Text("No other users registered yet."));
                }

                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 80, endIndent: 20, color: Color(0XFFF0F2F3)),
                  itemBuilder: (context, index) {
                    var userData = docs[index].data() as Map<String, dynamic>;
                    String name = userData['name'] ?? "Unknown User";
                    String profilePic = userData['profilePic'] ?? "";
                    String targetUid = userData['uid'] ?? docs[index].id;

                    return ListTile(
                      onTap: () {
                        // Navigate to details when chat is clicked
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => ChatDetailScreen(
                              userName: name,
                              targetUid: targetUid,
                              profilePic: profilePic,
                            )
                          )
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0XFFF0F2F3),
                        backgroundImage: profilePic.isNotEmpty ? NetworkImage(profilePic) : null,
                        child: profilePic.isEmpty ? const Icon(Icons.person, color: Colors.black26, size: 30) : null,
                      ),
                      title: Text(
                        name, 
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)
                      ),
                      subtitle: Text(
                        userData['phoneNumber'] ?? "No status", 
                        style: const TextStyle(color: Colors.black54, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis
                      ),
                      trailing: const Text("Now", style: TextStyle(color: Colors.black45, fontSize: 11)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Floating button to start a new chat
      floatingActionButton: FloatingActionButton(
        heroTag: "chats_fab",
        onPressed: () {},
        backgroundColor: const Color(0XFF25D366),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.add_comment, color: Colors.white, size: 22),
      ),
    );
  }

  // Widget helper for filter chips
  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0XFFE7FCE3) : const Color(0XFFF0F2F3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label, 
        style: TextStyle(
          color: isSelected ? const Color(0XFF018169) : Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
