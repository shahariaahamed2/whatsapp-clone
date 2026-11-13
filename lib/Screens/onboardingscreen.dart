import 'package:flutter/material.dart';
import 'package:app/Wedgets/uihelper.dart';
import 'package:app/Screens/Login/loginscreen.dart';

class OnBoardingscreen extends StatelessWidget {
  const OnBoardingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Step 1: Set the background color to white for a clean look
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            // Step 2: Show the welcome image from assets
            Image.asset(
              "assets/images/boarding.jpg",
              height: 250,
              width: 250,
            ),
            const SizedBox(height: 20),
            // Step 3: Main Heading text
            UiHelper.customText(
              text: "Welcome to WhatsApp",
              fontSize: 22,
              color: const Color(0XFF000000),
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            // Step 4: Privacy Policy and Terms of Service section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UiHelper.customText(text: "Read our ", fontSize: 14),
                      UiHelper.customText(
                        text: "Privacy Policy",
                        fontSize: 14,
                        color: const Color(0XFF0C42CC),
                      ),
                      UiHelper.customText(text: ". Tap 'Agree and continue'", fontSize: 14),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UiHelper.customText(text: " to accept the ", fontSize: 14),
                      UiHelper.customText(
                        text: "Terms of Service.",
                        fontSize: 14,
                        color: const Color(0XFF0C42CC),
                      ),
                    ],
                  ),
                ], 
              ),
            ),
            const SizedBox(height: 150), 

            // Step 5: Action Button to navigate to the Login Screen
            UiHelper.customButton(
              callback: () {
                // Moving forward to the LoginScreen
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const LoginScreen())
                );
              },
              buttonName: "Agree and Continue",
              backgroundColor: const Color(0xFF00A884),
              height: 35,
              width: 280,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
