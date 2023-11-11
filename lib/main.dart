import 'package:chat_app/log_views/LogInPage.dart';
import 'package:chat_app/log_views/SignInPage.dart';
import 'package:chat_app/screens/FindUser.dart';
import 'package:chat_app/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chat_app/screens/homeManagement.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/config/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 3, 112, 167)),
        useMaterial3: true,
      ),
      // home: const LogIn(),
      home: const HomeManagement(title: 'Horama Chat'),
    );
  }
}