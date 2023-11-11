import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

dynamic getUserData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userData = prefs.getString('user_info');
  dynamic decodedUserData = json.decode(userData.toString());
  return decodedUserData;
}
