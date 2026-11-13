import 'package:flutter/material.dart';
import 'package:app/Wedgets/uihelper.dart';

class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Onboarding image for Communities
            Image.asset(
              "assets/images/boarding.jpg", // You can replace this with a community image later
              height: 180,
              width: 180,
            ),
            const SizedBox(height: 25),
            
            // Heading text
            const Text(
              "Stay connected with a community",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Description text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Communities bring members together in topic-based groups, and make it easy to get admin announcements.",
                style: TextStyle(color: Colors.black54, fontSize: 14, fontFamily: 'Roboto'),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 35),
            
            // Custom button to start a community
            UiHelper.customButton(
              callback: () {}, 
              buttonName: "Start your community",
              width: 280,
              height: 35,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
