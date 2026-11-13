import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:app/Wedgets/uihelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/Screens/Home/homescreen.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  final TextEditingController nameController = TextEditingController();
  File? pickedImage;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image == null) return;
      setState(() {
        pickedImage = File(image.path);
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0XFF05AF82)),
                title: const Text('Take a Photo'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0XFF05AF82)),
                title: const Text('Choose from Gallery'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveProfile() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
      String phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber ?? "";
      String imageUrl = "";

      debugPrint("--- Starting Profile Save Process ---");
      debugPrint("User UID: $uid");

      // 1. Upload to Storage
      if (pickedImage != null) {
        debugPrint("Uploading image to Storage...");
        Reference storageRef = FirebaseStorage.instance.ref().child("profile_images").child("$uid.jpg");
        await storageRef.putFile(pickedImage!);
        imageUrl = await storageRef.getDownloadURL();
        debugPrint("Image upload successful: $imageUrl");
      }

      // 2. Save to Firestore
      debugPrint("Saving data to Firestore...");
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "uid": uid,
        "name": nameController.text.trim(),
        "phoneNumber": phoneNumber,
        "profilePic": imageUrl,
        "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
      });
      debugPrint("Firestore save successful!");

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => const Homescreen()), 
          (route) => false
        );
      }
    } catch (e) {
      debugPrint("CRITICAL ERROR: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 80),
                UiHelper.customText(
                  text: "Profile Info",
                  fontSize: 20,
                  color: const Color(0XFF00A884),
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 30),
                const Text("Please provide your name and an optional profile photo"),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: _showImagePicker,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color(0XFFD9D9D9),
                    backgroundImage: pickedImage != null ? FileImage(pickedImage!) : null,
                    child: pickedImage == null
                        ? const Icon(Icons.add_a_photo, color: Color(0XFF5E5E5E), size: 30)
                        : null,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: "Type your name here",
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0XFF05AF82), width: 2)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0XFF05AF82), width: 2)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.face, color: Color(0XFF5E5E5E)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator(color: Color(0xFF00A884))),
            ),
        ],
      ),
      floatingActionButton: isLoading 
          ? null 
          : UiHelper.customButton(
              callback: _saveProfile,
              buttonName: "Next",
              width: 300,
              height: 35,
              fontSize: 15,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
