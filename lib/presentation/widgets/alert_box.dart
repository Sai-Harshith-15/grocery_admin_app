import 'package:flutter/material.dart';

import 'inkwell_button.dart';
import 'mytext.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({super.key});

  get textAlign => null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.close),
                  ),
                ),
                const SizedBox(height: 48),
                // Asset Image in the center
                Image.asset(
                  'assets/images/fav.jpeg', // Change this to your image asset path
                  height: 100,
                ),
                const SizedBox(height: 24),
                // Heading and Subtext
                const HeadText(
                  text: "Oops! Order Failed",
                  textSize: 24,
                  textWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const HeadText(
                  text: "Something went terribly wrong.",
                  textSize: 18,
                  textWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 50),
                InkWellButton(text: "Try Again", onPressed: () {}),

                const SizedBox(height: 16),
                // Back to Home Button
                TextButton(
                  onPressed: () {
                    // Handle Back to Home action here
                  },
                  child: const HeadText(
                    text: "Back to home",
                    textSize: 18,
                    textWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
