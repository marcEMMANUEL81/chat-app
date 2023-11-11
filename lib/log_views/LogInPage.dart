// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:convert';
import 'package:chat_app/log_views/SignInPage.dart';
import 'package:chat_app/screens/HomeManagement.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/inputType.dart';
import '../constants/const.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

// Variables initializing

final lastnameController = TextEditingController();
final nameController = TextEditingController();
final numberController = TextEditingController();
final passwordController = TextEditingController();

bool isLoading = false;
bool isReadyToNavigate = false;

class _LogInState extends State<LogIn> {
  // Consum API for registration

  Future<void> createtUser(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var body = json.encode(data);

    dynamic response = (await http.post(
      Uri.parse('${dotenv.env['BASE_URL']}auth/signup'),
      headers: headers,
      body: body,
    ));

    dynamic responseData = json.decode(response.body);

    if (response.statusCode == 201) {
      showStatus(context, "Bienvenue champion !", false);
      dynamic storedData = json.encode(responseData["data"]);

      setState(() {
        prefs.setString(
          'user_info',
          storedData,
        );
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeManagement(title: "Horama Chat",),
        ),
      );

    } else {
      showStatus(context, "Un manioc s'est produit !", true);
      setState(() {
        isLoading = false;
      });
      print(responseData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.network(
              "https://images.pexels.com/photos/2040745/pexels-photo-2040745.jpeg?auto=compress&cs=tinysrgb&w=800",
              fit: BoxFit.cover,
              height: 350,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(top: 270),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  addSpace(20),
                  Text(
                    "Remplissez les champs ci dessous",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    // key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InputTemlate(
                                type: "text",
                                title: "Votre nom",
                                size: MediaQuery.of(context).size.width * 0.32,
                                placeholder: "Papa",
                                textController: lastnameController,
                              ),
                              InputTemlate(
                                type: "text",
                                title: "Votre prénom",
                                size: MediaQuery.of(context).size.width * 0.55,
                                placeholder: "Roger",
                                textController: nameController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InputTemlate(
                          type: "text",
                          title: "Votre numéro",
                          size: MediaQuery.of(context).size.width,
                          placeholder: "0797674576",
                          textController: numberController,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InputTemlate(
                          type: "password",
                          title: "Votre mot de passe",
                          size: MediaQuery.of(context).size.width - 88,
                          placeholder: "",
                          textController: passwordController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  isLoading == true
                      ? loader
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              dynamic data = {
                                "firstname": lastnameController.value.text,
                                "lastname": nameController.value.text,
                                "phone_number": numberController.value.text,
                                "password": passwordController.value.text
                              };

                              if (lastnameController.text.isNotEmpty &&
                                  nameController.text.isNotEmpty &&
                                  numberController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                setState(() {
                                  isLoading = true;
                                });

                                createtUser(data);
                              } else {
                                showStatus(
                                  context,
                                  "Remplissez correctement tous les champs",
                                  true,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 25,
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "Continuer",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 58,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignIn(),
                              ),
                            );
                          },
                          child: const FaIcon(
                            FontAwesomeIcons.chevronRight,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      addWidth(20),
                      Text(
                        'Vous avez \ndéjà un compte ?',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  addSpace(30),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
