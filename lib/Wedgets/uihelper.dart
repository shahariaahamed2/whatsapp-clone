import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UiHelper {
  // A custom button that can be used throughout the app
  static Widget customButton({
    required VoidCallback callback,
    required String buttonName,
    Color? backgroundColor,
    double? height,
    double? width,
    double? fontSize,
  }) {
    return SizedBox(
      height: height ?? 45,
      width: width ?? 330,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFF00A884), // Default WhatsApp Green
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          callback();
        },
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: fontSize ?? 20,
            color: Colors.white,
            fontFamily: 'Roboto', // Global font preference
          ),
        ),
      ),
    );
  }

  // A custom text widget to maintain consistent styling
  static Widget customText({
    required String text,
    required double fontSize,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? const Color(0XFF5E5E5E),
        fontWeight: fontWeight,
        fontFamily: 'Roboto',
      ),
    );
  }

  // A custom container for OTP input boxes
  static Widget CustomContainer(TextEditingController controler, BuildContext context, {bool isLast = false}) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0XFFD9D9D9),
      ),
      child: Center(
        child: TextField(
          controller: controler,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1), // Allow only 1 digit
            FilteringTextInputFormatter.digitsOnly, // Allow only numbers
          ],
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          onChanged: (value) {
            if (value.length == 1) {
              if (!isLast) {
                // Automatically move to the next box
                FocusScope.of(context).nextFocus();
              } else {
                // Close the keyboard if it's the last box
                FocusScope.of(context).unfocus();
              }
            }
          },
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
