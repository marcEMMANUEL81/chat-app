// ignore_for_file: file_names
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chat_app/screens/FindUser.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chat_app/constants/const.dart';
import 'package:chat_app/widgets/chatBox.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../widgets/SidebarWidget.dart';
import '../constants/test.dart';
import '../helpers.dart';
import 'dart:convert';

class HomeManagement extends StatefulWidget {
  const HomeManagement({super.key, required this.title});
  final String title;

  @override
  State<HomeManagement> createState() => _HomeManagementState();
}

class _HomeManagementState extends State<HomeManagement> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List? fullData;
  bool isLoading = true;
  String firstname = "";
  String lastname = "";
  String phone_number = "";

  @override
  void initState() {
    getUserInformations();
    getConversations();
    super.initState();
  }

  getUserInformations() async {
    dynamic userInfo = await getUserData();
    setState(() {
      firstname = userInfo["firstname"];
      lastname = userInfo["lastname"];
      phone_number = userInfo["phone_number"];
    });
  }

  Future<void> getConversations() async {
    dynamic userId = await getUserData();
    String id = userId["id"];

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    dynamic response = (await http.get(
      Uri.parse('${dotenv.env['BASE_URL']}chats/$id'),
      headers: headers,
    ));

    print("ici");
    final responseData = jsonDecode(response.body);
    print(responseData);

    if (response.statusCode == 200) {
      setState(() {
        fullData = responseData["data"];
      });
    } else {
      showStatus(context, "un manioc s'est produit !", true);
      print(responseData);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.barsStaggered,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.penToSquare,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FindUserPage(),
                ),
              );
            },
          ),
        ],
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? loader
          : SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Discussions",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 3, 112, 167),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 55,
                      child: TextField(
                        controller: _searchController,
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
                      height: 30,
                    ),
                    fullData!.isEmpty ? const Center(child: Text("Aucune discussion"),) : Column(
                      children: List<Widget>.generate(
                        fullData!.length,
                        (int index) {
                          var user = fullData![index];
                          return chatBox(
                            context,
                            "${user["receiverInfo"]["firstname"]} ${user["receiverInfo"]["lastname"]}",
                            "",
                            user["messages"][0]["content"],
                            "${user["receiverInfo"]["firstname"]} $index",
                            "${user["receiverInfo"]["lastname"]} $index",
                            user["messages"],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      drawer: Drawer(
        child: myDrawer(
          "$firstname $lastname",
          phone_number,
          context,
        ),
      ),
    );
  }
}
