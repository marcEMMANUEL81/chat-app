import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../constants/const.dart';
import '../helpers.dart';
import 'dart:convert';

import 'chatScreen.dart';

class FindUserPage extends StatefulWidget {
  const FindUserPage({super.key});

  @override
  State<FindUserPage> createState() => _FindUserPageState();
}

class _FindUserPageState extends State<FindUserPage> {
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  Future<void> getUsers() async {
    dynamic userData = await getUserData();
    print(userData);
    String id_user = userData["id"];
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    dynamic response = (await http.get(
      Uri.parse('${dotenv.env['BASE_URL']}users'),
      headers: headers,
    ));

    dynamic responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      users = responseData["data"];
      print(users);
      users.removeWhere((user) => user["id"] == id_user);
      print(users);
      setState(() {
        filteredUsers = users;
      });
    } else {
      showStatus(context, "une erreur s'est produite !", true);
      print(responseData);
    }
    setState(() {
      isLoading = false;
    });
  }

  List users = [];

  List filteredUsers = [];

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  void filterUsers(String query) {
    print(query);
    List filteredList = users
        .where((user) =>
            user["firstname"].toLowerCase().contains(query.toLowerCase()) ||
            user["lastname"].toLowerCase().contains(query.toLowerCase()) ||
            user["phone_number"].contains(query.toString()))
        .toList();

    setState(() {
      filteredUsers = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            );
          },
        ),
        title: Text(
          "Trouver un utilisateur",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: isLoading
          ? loader
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 55,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (query) => filterUsers(query),
                        decoration: InputDecoration(
                          hintText: 'Rechercher...',
                          hintStyle: GoogleFonts.poppins(),
                          labelStyle: GoogleFonts.poppins(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => _searchController.clear(),
                          ),
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (filteredUsers.isEmpty)
                      const Center(
                        child: Text("\n\n\nAucun utilisateur"),
                      )
                    else
                      Column(
                        children: List<Widget>.generate(
                          filteredUsers.length,
                          (int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreenPage(
                                      username: filteredUsers[index]["firstname"].toUpperCase(),
                                      imageLink: "",
                                      userTag: "${filteredUsers[index]["firstname"]} $index",
                                      userTag_name: "${filteredUsers[index]["firstname"]} $index",
                                      conversation: const [],
                                      receiver_id: filteredUsers[index]["id"],
                                    ),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 90,
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${filteredUsers[index]["firstname"].toUpperCase()} ${filteredUsers[index]["lastname"]} ",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${filteredUsers[index]["phone_number"]}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
