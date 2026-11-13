import 'package:app/Wedgets/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/Screens/OTP/otpscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedcountry = "Bangladesh";
  
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController(text: "+880");

  final List<String> countries = [
    "Japan", "America", "Bangladesh", "India", "Pakistan", "Sri Lanka", "Nepal", "Bhutan"
  ];

  final Map<String, String> countryCodes = {
    "Japan": "+81",
    "America": "+1",
    "Bangladesh": "+880",
    "India": "+91",
    "Pakistan": "+92",
    "Sri Lanka": "+94",
    "Nepal": "+977",
    "Bhutan": "+975"
  };

  final Map<String, int> countryLengths = {
    "Japan": 10,
    "America": 10,
    "Bangladesh": 10,
    "India": 10,
    "Pakistan": 10,
    "Sri Lanka": 9,
    "Nepal": 10,
    "Bhutan": 8
  };

  @override
  void dispose() {
    _codeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int maxLength = countryLengths[selectedcountry] ?? 10;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 80),
          Center(
            child: UiHelper.customText(
              text: "Enter your phone number",
              fontSize: 20,
              color: const Color(0XFF00A884),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          UiHelper.customText(
            text: "WhatsApp will need to verify your phone ", 
            fontSize: 14,
          ),
          UiHelper.customText(
            text: "number. Carrier charges may apply.", 
            fontSize: 14,
          ),
          const SizedBox(height: 40),
          
          // Country selection dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: DropdownButtonFormField<String>(
              // Replaced deprecated 'value' with 'initialValue'
              // Added ValueKey to ensure the widget rebuilds correctly when country changes
              key: ValueKey(selectedcountry),
              initialValue: selectedcountry,
              items: countries.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country, style: const TextStyle(fontSize: 16)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedcountry = value;
                    _codeController.text = countryCodes[value] ?? "";
                    _phoneController.clear();
                  });
                }
              },
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF00A884), width: 1.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF00A884), width: 2),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Phone Input Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 65,
                  child: TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF00A884), width: 1.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF00A884), width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 18, letterSpacing: 1.5),
                    inputFormatters: [
                      // Set max length based on selected country
                      LengthLimitingTextInputFormatter(maxLength),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      // Logic: Auto-remove leading '0' like official WhatsApp
                      if (value.startsWith('0')) {
                        _phoneController.text = value.substring(1);
                        _phoneController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _phoneController.text.length),
                        );
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "phone number",
                      counterText: "",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF00A884), width: 1.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF00A884), width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      floatingActionButton: UiHelper.customButton(
        callback: () {
          String phone = _phoneController.text.trim();
          String code = _codeController.text.trim();
          
          if (phone.length != maxLength) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please enter a valid $maxLength-digit number for $selectedcountry"),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            login(code + phone);
          }
        },
        buttonName: "Next",
        backgroundColor: const Color(0xFF00A884),
        height: 40,
        width: 280,
        fontSize: 16,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void login(String fullnumber) async {
    // Show Loading indicator
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00A884)),
          );
        });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullnumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          if (!mounted) return;
          Navigator.pop(context); // Close loading
          
          String userFriendlyMessage = "Error: ${e.message}";
          
          // Advice for Internal Errors and Security Check
          if (e.code == 'app-not-authorized') {
            userFriendlyMessage = "Firebase Error: App not authorized. Please double check SHA-1/SHA-256 fingerprints in Firebase Console and ensure Phone Auth is Enabled.";
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(userFriendlyMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 10),
            ),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!mounted) return;
          Navigator.pop(context); // Close loading
          
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPScreen(
                        phonenumber: fullnumber,
                        verificationId: verificationId,
                      )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (ex) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Internal Exception: ${ex.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
