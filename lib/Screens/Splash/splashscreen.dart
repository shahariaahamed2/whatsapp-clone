import 'dart:async';
import 'package:app/Screens/onboardingscreen.dart';
import 'package:flutter/material.dart';
import 'package:app/Wedgets/uihelper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    
    // Step 1: Wait for 3 seconds before moving to the next screen
    Timer(const Duration(seconds: 3), () {
      
      // Step 2: Ensure the widget is still active in the app tree
      if (mounted) {
        // Step 3: Navigate to OnBoardingscreen and remove Splash from history
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const OnBoardingscreen())
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the logo image
            Image.asset( 
              'assets/images/OIP.webp',
              height: 55,
              width: 55,
            ),
            const SizedBox(height: 10),
            
            // Display the text 'WhatsApp' using our helper
            UiHelper.customText(
              text: 'WhatsApp',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00A884)
            ),
          ],
        ),
      ),
    );
  }
}
