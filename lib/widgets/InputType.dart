// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class InputTemlate extends StatefulWidget {
  const InputTemlate({
    Key? key,
    required this.type,
    required this.title,
    required this.size,
    required this.placeholder,
    required this.textController,
  }) : super(key: key);
  final String type;
  final String title;
  final double size;
  final String placeholder;
  final TextEditingController textController;

  @override
  State<InputTemlate> createState() => _InputTemlateState();
}

class _InputTemlateState extends State<InputTemlate> {
  bool show = true;

  void showHidePassword() {
    if (show == true) {
      setState(() {
        show = false;
      });
    } else {
      setState(() {
        show = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == "text"
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: widget.size,
                child: TextField(
                  controller: widget.textController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 2.0,
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: widget.placeholder,
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: widget.size,
                    child: TextField(
                      obscureText: show,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: widget.textController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: widget.placeholder,
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showHidePassword();
                    },
                    icon: show
                        ? const FaIcon(
                            FontAwesomeIcons.eyeSlash,
                            color: Colors.blue,
                            size: 21,
                          )
                        : const FaIcon(
                            FontAwesomeIcons.eye,
                            color: Colors.blue,
                            size: 21,
                          ),
                  ),
                ],
              )
            ],
          );
  }
}

Widget caseInput(context, controller) {
  return SizedBox(
    width: 50,
    height: 50,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) => {
          if (value.length == 1) {FocusScope.of(context).nextFocus()}
        },
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 7),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: '',
          hintStyle: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
