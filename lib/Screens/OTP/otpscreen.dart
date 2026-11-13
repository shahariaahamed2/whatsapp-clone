import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/Wedgets/uihelper.dart';
import 'package:app/Screens/Profile/profilescreen.dart';

class OTPScreen extends StatelessWidget {
  final String phonenumber;
  final String verificationId;
  
  OTPScreen({super.key, required this.phonenumber, required this.verificationId});
  
  // Controllers to store each digit of the OTP
  final TextEditingController otp1controller = TextEditingController();
  final TextEditingController otp2controller = TextEditingController();
  final TextEditingController otp3controller = TextEditingController();
  final TextEditingController otp4controller = TextEditingController();
  final TextEditingController otp5controller = TextEditingController();
  final TextEditingController otp6controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                // Header text for the OTP screen
                UiHelper.customText(
                  text: "Verify your number", 
                  fontSize: 16,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0XFF00A884),
                ),
                const SizedBox(height: 20),
                // Showing the space-formatted unified phone number cleanly
                UiHelper.customText(
                  text: "You've tried to register $phonenumber", 
                  fontSize: 16,
                ),
                UiHelper.customText(
                  text: "recently. Wait before requesting an SMS or a call", 
                  fontSize: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UiHelper.customText(text: "with your code.", fontSize: 16),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        // Go back to LoginScreen if the number is wrong
                        Navigator.pop(context);
                      },
                      child: UiHelper.customText(
                        text: "Wrong Number?", 
                        fontSize: 16, 
                        color: const Color(0XFF00A884),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // OTP Input Boxes row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    UiHelper.CustomContainer(otp1controller, context, isLast: false),
                    UiHelper.CustomContainer(otp2controller, context, isLast: false),
                    UiHelper.CustomContainer(otp3controller, context, isLast: false),
                    UiHelper.CustomContainer(otp4controller, context, isLast: false),
                    UiHelper.CustomContainer(otp5controller, context, isLast: false),
                    UiHelper.CustomContainer(otp6controller, context, isLast: true),
                  ],
                ),
                const SizedBox(height: 30),
                UiHelper.customText(
                  text: "Didn't receive code?", 
                  fontSize: 16,
                  color: const Color(0XFF00A884),
                ),
              ],
            ),
          ),
        ],
      ),
      // Action button to verify and proceed
      floatingActionButton: UiHelper.customButton(
        callback: () {
          // Logic: Check if all 6 boxes are filled
          if (otp1controller.text.isEmpty ||
              otp2controller.text.isEmpty ||
              otp3controller.text.isEmpty ||
              otp4controller.text.isEmpty ||
              otp5controller.text.isEmpty ||
              otp6controller.text.isEmpty) {
            // Show error message using SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Enter your correct OTP"),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            // Combine OTP digits
            String smsCode = otp1controller.text +
                otp2controller.text +
                otp3controller.text +
                otp4controller.text +
                otp5controller.text +
                otp6controller.text;
                
            // Verify OTP with Firebase
            verifyOTP(context, smsCode);
          }
        },
        buttonName: "Next", 
        backgroundColor: const Color(0xFF00A884), 
        height: 30, 
        width: 300, 
        fontSize: 15,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Method to verify OTP with Firebase Auth
  void verifyOTP(BuildContext context, String smsCode) async {
    // Show loading dialog
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00A884),
            ),
          );
        });

    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Sign the user in with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Close loading dialog
      Navigator.pop(context);

      // Navigate to the Profile setup screen and clear stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Profilescreen()),
        (route) => false,
      );
    } catch (ex) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid OTP: ${ex.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
