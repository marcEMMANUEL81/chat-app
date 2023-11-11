import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

Widget addWidth(double width) {
  return SizedBox(
    width: width,
  );
}

Widget addSpace(double height) {
  return SizedBox(
    height: height,
  );
}


const loader = SpinKitThreeBounce(
  color: Colors.blue,
  size: 40.0,
);

void showStatus(BuildContext context, String text, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
}
