import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chat_app/log_views/SignInPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers.dart';

Future<void> logOutUser(data) async {
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };

  await http.get(
    Uri.parse('${dotenv.env['BASE_URL']}auth/logout/$data'),
    headers: headers,
  );
}

Widget myDrawer(userName, phoneNumber, context) {
  return ListView(
    padding: EdgeInsets.zero,
    children: [
      UserAccountsDrawerHeader(
        currentAccountPicture: const CircleAvatar(
          backgroundImage: NetworkImage(
            'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=2000&t=st=1684258522~exp=1684259122~hmac=3affa032df7e0e12965c7af0c553b5894ca8e96ddb1022605aca0a1c8e26ad5a',
          ),
        ),
        accountEmail: Text(
          phoneNumber,
          style: GoogleFonts.poppins(
            fontSize: 13.9,
            color: Colors.black,
          ),
        ),
        accountName: Text(
          userName,
          style: GoogleFonts.poppins(
            fontSize: 24.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
      ListTile(
        leading: const FaIcon(
          FontAwesomeIcons.user,
          color: Colors.blue,
          size: 20,
        ),
        title: Text(
          'Compte',
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        onTap: () {},
      ),
      ListTile(
        leading: const FaIcon(
          FontAwesomeIcons.rightFromBracket,
          color: Colors.blue,
          size: 20,
        ),
        title: Text(
          'Déconnexion',
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        onTap: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          dynamic decodedInfo = await getUserData();
          logOutUser(decodedInfo["id"]);

          await prefs.clear();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignIn(),
            ),
          );
        },
      ),
    ],
  );
}
