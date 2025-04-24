import 'dart:convert';
import 'package:ibh/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  // final box = GetStorage();
  var pref = SharedPreferences.getInstance();
  var userKey = "user";
  var tokenKey = "token";
  var loginKey = "login";
  var latKey = "lat";
  var longKey = "long";

  getPref() async {
    return await SharedPreferences.getInstance();
  }

  read() async {
    pref = SharedPreferences.getInstance();
  }

  void saveSignInInfo(User? data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(loginKey, json.encode(data));
  }

  Future<User?> getSignInInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(loginKey);
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      return User.fromJson(jsonMap);
    }
    return null;
  }

  Future<void> setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, value);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) ?? "";
  }

  Future<void> setUserType(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, value);
  }

  Future<String> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userKey) ?? "";
  }

  Future<void> setBool(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(latKey, value);
  }

  Future<bool> getBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(latKey) ?? false;
  }

  Future<void> setLat(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(latKey, value);
  }

  Future<String> getLat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(latKey) ?? "";
  }

  Future<void> setLong(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(longKey, value);
  }

  Future<String> getLong() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(longKey) ?? "";
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
