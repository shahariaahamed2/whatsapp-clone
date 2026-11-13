import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userName;
  final String targetUid;
  final String profilePic;

  const ChatDetailScreen({
    super.key, 
    required this.userName, 
    required this.targetUid, 
    required this.profilePic
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String currentUid;
  late String chatroomId;

  @override
  void initState() {
    super.initState();
    currentUid = FirebaseAuth.instance.currentUser?.uid ?? "";
    
    // Create a unique chatroom ID for 1-to-1 chat by sorting their UIDs
    if (currentUid.compareTo(widget.targetUid) > 0) {
      chatroomId = "${currentUid}_${widget.targetUid}";
    } else {
      chatroomId = "${widget.targetUid}_${currentUid}";
    }
  }

  void _sendMessage() async {
    String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      _messageController.clear();

      var messageData = {
        "senderId": currentUid,
        "receiverId": widget.targetUid,
        "message": text,
        "timestamp": FieldValue.serverTimestamp(),
        "timeString": "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}"
      };

      // Add message to Firestore
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomId)
          .collection("chats")
          .add(messageData);

      // Auto scroll to bottom
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFE5DDD5),
      appBar: AppBar(
        backgroundColor: const Color(0XFF018169),
        leadingWidth: 70,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              const SizedBox(width: 5),
              const Icon(Icons.arrow_back, size: 24),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                backgroundImage: widget.profilePic.isNotEmpty ? NetworkImage(widget.profilePic) : null,
                child: widget.profilePic.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 20) : null,
              ),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
            const Text("online", style: TextStyle(fontSize: 11, fontFamily: 'Roboto')),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam, size: 22)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call, size: 22)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert, size: 22)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("chatrooms")
                  .doc(chatroomId)
                  .collection("chats")
                  .orderBy("timestamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0XFF018169)));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Say Hi! 👋", style: TextStyle(color: Colors.black54, fontSize: 16)),
                  );
                }

                var docs = snapshot.data!.docs;
                
                // Trigger scroll to bottom on new messages after build
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index].data() as Map<String, dynamic>;
                    bool isMe = data['senderId'] == currentUid;
                    return _buildMessageBubble(
                      data['message'] ?? "", 
                      isMe, 
                      data['timeString'] ?? ""
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe, String time) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isMe ? const Color(0XFFE7FFDB) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(text, style: const TextStyle(fontSize: 15, color: Colors.black87, fontFamily: 'Roboto')),
            const SizedBox(height: 2),
            Text(time, style: const TextStyle(fontSize: 10, color: Colors.black45, fontFamily: 'Roboto')),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Message",
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file, color: Colors.grey)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt, color: Colors.grey)),
                    ],
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: const CircleAvatar(
              backgroundColor: Color(0XFF018169),
              radius: 22,
              child: Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
