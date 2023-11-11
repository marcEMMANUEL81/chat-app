// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chat_app/log_views/LogInPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/HomeManagement.dart';
import 'package:flutter/material.dart';
import '../widgets/InputType.dart';
import '../constants/const.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

final _formKey = GlobalKey<FormState>();
final numberController = TextEditingController();
final passwordController = TextEditingController();

class _SignInState extends State<SignIn> {
  bool isReadyToNavigate = false;
  bool isLoading = false;

  Future<void> connectUser(
    Map<String, String> data,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var body = json.encode(data);

    dynamic response = (await http.post(
      Uri.parse('${dotenv.env['BASE_URL']}auth/login'),
      headers: headers,
      body: body,
    ));

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
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
          builder: (context) => const HomeManagement(
            title: "Horama Chat",
          ),
        ),
      );
    } else {
      showStatus(context, "Email ou mot de passe incorrect", true);
      setState(() {
        isLoading = false;
      });
      throw Exception(responseData.toString());
    }

    numberController.clear;
    passwordController.clear;
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
                    key: _formKey,
                    child: Column(
                      children: [
                        InputTemlate(
                          type: "text",
                          title: "Votre numéro de téléphone",
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
                            onPressed: () async {
                              dynamic data = {
                                "phone_number": numberController.value.text,
                                "password": passwordController.value.text
                              };

                              if (numberController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                setState(() {
                                  isLoading = true;
                                });
                                await connectUser(data);
                              } else {
                                showStatus(
                                  context,
                                  "Remplissez coorectement tous les champs",
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
                                fontSize: 18,
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
                                builder: (context) => const LogIn(),
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
                        'Vous n\'avez \npas encore de compte ?',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
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
