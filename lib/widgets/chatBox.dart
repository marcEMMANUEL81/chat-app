// ignore_for_file: file_names

import 'package:chat_app/screens/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget chatBox(
  context,
  String name,
  String imageUrl,
  String message,
  String userTag_pic,
  String userTag_name,
  dynamic conversation,
) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreenPage(
            username: name,
            imageLink: imageUrl,
            userTag: userTag_pic,
            userTag_name: userTag_name,
            conversation: conversation,
            receiver_id: "1",
          ),
        ),
      );
    },
    child: Row(
      children: [
        Hero(
          tag: userTag_pic,
          child: CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(
              imageUrl,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: .5,
                  color: Colors.black.withOpacity(.2),
                ),
                bottom: BorderSide(
                  width: .5,
                  color: Colors.black.withOpacity(.1),
                ),
              ),
            ),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: userTag_name,
                    child: Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    message.length < 70
                        ? message
                        : "${message.substring(0, 70)} ...",
                    style: GoogleFonts.poppins(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
