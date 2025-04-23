// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class SignupPreferences {
//   // final box = GetStorage();

//   static const String userKey = "UserData";

//   Future<void> saveUserData(UserData user) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String jsonString = json.encode(user.toJson());
//     await pref.setString(userKey, jsonString);
//   }

//   Future<UserData?> getUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? jsonString = prefs.getString(userKey);
//     if (jsonString != null) {
//       Map<String, dynamic> jsonMap = json.decode(jsonString);
//       return UserData.fromJson(jsonMap);
//     }
//     return null;
//   }

//   void logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }
// }
